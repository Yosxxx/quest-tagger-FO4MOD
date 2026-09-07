# Implementation

## Pipeline

```
Database/quests.json          hand-maintained, source of truth
        |
        |  build/package.py
        v
Database/quests.tsv  ------->  Scripts/AuditQuests.pas      (read-only, in FO4Edit)
                                       |
                                       v
                               output/quests.candidate.tsv  <- real FormIDs + EditorIDs
                               output/audit_report.txt
                               output/unknown.tsv
                                       |
                                       |  merge back into quests.json
                                       v
                               Scripts/GenerateQuestMarkers.pas  (creates the .esp files)
                                       |
                                       v
                               Scripts/ValidateQuestMarkers.pas  (proves nothing else changed)
                                       |
                                       v
                               build/package.py  -> dist/RadiantQuestMarker-x.y.z.zip
```

## Why the audit exists

The design brief says repeatedly: *verify the exact FormIDs and repeatability from the current game
files before implementation*. That verification cannot be done from documentation. A FormID is a
property of a specific plugin build, and "is this quest repeatable" is a property of record flags and
Story Manager wiring, not of a wiki page.

So the shipped database ships **no** `verified` entries. It ships names, tags, module assignments and
an evidence note per entry, at `likely` or `unverified`. The audit resolves those against your actual
install and is the only component allowed to write `verified`.

This is why `quests.json` has null `formID` and `editorID` columns. They are not placeholders that
somebody forgot to fill in — filling them in from memory is precisely the failure mode the brief's
section 22 is guarding against.

## How classification works

Names are a match key, never evidence. Classification comes from records:

| Signal | Weight | Source |
| --- | --- | --- |
| Referenced by a Story Manager Quest Node (`SMQN`) | 3 | `ReferencedByCount` / `ReferencedByIndex` |
| `DNAM\Flags` contains `Allow repeated stages` | 2 | flags |
| `DNAM\Flags` contains `Repeats conditions` | 2 | flags |
| EditorID matches a known radiant family | 2 | `radiant_rules.json` |
| `DNAM\Flags` does **not** contain `Run Once` | 1 | flags |
| An alias fills from an event rather than a unique reference | advisory | alias inspection |

The SMQN reference is the strongest signal available. A quest the engine issues procedurally is
wired to a story node; a quest a script starts once is not. A record needs a score of 3 or more to be
proposed, and `SMQN > 0` **plus** an EditorID family match to reach `verified`. One point alone is
just "not run once", which nearly every quest satisfies, so it never qualifies anything on its own.

Hard exclusions run first and are absolute: an empty `FULL` (controllers and dialogue quests never
appear in the log), the `Run Once` flag, and EditorID prefixes like `Dialogue*`, `WorkshopParent*`,
`MQ*` or anything containing `Controller` / `Manager` / `Template`.

Settlement involvement never contributes to the radiant score. It only chooses between tag variants
once a quest has already qualified on other evidence. That is section 13 of the brief implemented
directly rather than promised.

### Reference info

The SMQN check needs xEdit's reference info, which is built on load by default. If it is off, the
signal silently reports zero and everything falls back to `likely`. The audit report prints a warning
when this happens rather than quietly producing weaker results.

## Idempotency

`StripKnownTags` removes any tag from **either** style from the front of a display name, longest
first, looping until nothing more matches. Then the new tag is applied. Consequences:

- Running the generator twice produces the same name, not a doubled prefix.
- Switching from descriptive to compact rewrites cleanly instead of stacking.
- A quest name that legitimately starts with an unrelated bracket is left alone, because only exact
  tokens from the known vocabulary are stripped.
- Longest-first ordering means `[Settlement - Establishment]` is never partially eaten by
  `[Settlement - Radiant]`.

`ValidateQuestMarkers.pas` re-derives this independently: it counts leading tags and fails on
anything other than exactly one, then checks the stripped remainder still equals the master's name.

## Module layout

Modules are **disjoint** — every quest lands in exactly one. This matters for the installer: if
`[Timed]` quests lived in both the Vanilla plugin and a Timed plugin, toggling the Timed option would
produce two plugins overriding the same QUST and the result would depend on load order.

Assignment order (first match wins):

1. source plugin matches `cc*` -> `NextGen`
2. `Fallout4.esm` and timed -> `Timed`
3. `Fallout4.esm` and settlement category -> `Settlement`
4. otherwise the DLC's own module, or `Vanilla`

DLC quests that are also timed or settlement-related stay in their DLC module rather than spawning
`QuestMarkers_FarHarbor_Timed.esp` and friends. This keeps the plugin count at nine instead of
twenty-odd, at the cost of those quests following the DLC toggle rather than the timed toggle.

## ESL flagging

Every module is override-only and creates zero new records, so ESL flagging is always valid — the
`0x000`–`0xFFF` new-record limit that normally makes ESL risky simply does not apply. The validation
script counts new records per plugin and reports the ESL verdict explicitly rather than asserting it.

Files are named `.esp` with the ESL flag set rather than `.esl`. ESL-flagged ESPs sort in the regular
plugin section, which makes conflict resolution against other quest-name mods visible in xEdit and
LOOT instead of hidden in the `FE` block.

## Copy source

`USE_WINNING_OVERRIDE` controls what gets copied.

- `False` (default) copies from the official master record. Masters stay limited to Bethesda plugins,
  which is what you want for a redistributable package.
- `True` copies from the current winning override, so another mod's changes to the same QUST are
  preserved and only the name is layered on top. This adds that mod as a master, so it is for
  personal builds, not for release.

## Build workflow

```
1. python build/package.py --no-zip
2. Copy Database\quests.tsv and Scripts\*.pas into
   <FO4Edit>\Edit Scripts\RadiantQuestMarker\
3. Launch FO4Edit, load Fallout4.esm + DLC + cc*.esl
4. Apply Script -> AuditQuests
5. Review output\audit_report.txt and output\unknown.tsv
6. Merge output\quests.candidate.tsv into Database\quests.json
   (real FormIDs and EditorIDs, promoted confidence)
7. python build/package.py --no-zip     # regenerate the TSV and docs
8. Set TAG_STYLE = 'descriptive' in GenerateQuestMarkers.pas -> Apply Script
9. Save the new plugins, move them into Plugins\Descriptive\<Module>\
10. Set TAG_STYLE = 'compact', repeat, move into Plugins\Compact\<Module>\
11. Reload FO4Edit with the built plugins -> Apply Script -> ValidateQuestMarkers
12. python build/package.py            # packages dist\RadiantQuestMarker-x.y.z.zip
```

Set `DRY_RUN = True` in the generator to get the full report without creating anything. That is the
fastest way to see what a database change would do.

## xEdit compatibility notes

- Built against the FO4Edit 4.1.5f scripting API.
- `SetIsESL` is wrapped in a try/except; older builds print a note and you set the flag by hand.
- `FixedFormID` is used for the file-local FormID in reports. If your xEdit build lacks it, swap in
  `GetLoadOrderFormID(rec) and $00FFFFFF` for `.esm` masters — note that this is wrong for `FE`-indexed
  `cc*.esl` files, which is why the Creation Club entries key on EditorID instead.
- All three scripts do their work in `Initialize` and return an empty `Process`, so it does not matter
  which record you right-click to launch them.
