# Compatibility

## The one real conflict

This mod changes `QUST \ FULL - Name`. Any other mod that changes the same field on the same quest
will conflict, and the plugin loaded later wins outright. There is no partial merge for a string.

Mods likely to collide:

| Category | Example behaviour | Result |
| --- | --- | --- |
| Other quest-tagging mods | Prefix or renames quests | Direct conflict, load order decides |
| Quest overhauls | Rewrite quest names as part of a rework | Their name wins if loaded later |
| Translations / localisations | Replace `FULL` with translated strings | Their name wins, or ours does and you lose the translation |
| Quest-removal mods | Delete or disable radiant quests | Our override may resurrect a record they removed |

Everything else is safe by construction. Scripts, stages, objectives, aliases, conditions, rewards,
dialogue, quest flags, start triggers and stop conditions are never touched, so mods that change
those fields on the same quest merge cleanly — xEdit will show a conflict on the record, but only
the name row is coloured.

## Load order

Put the `QuestMarkers_*` plugins **after** anything that legitimately renames quests if you want
their names, or **after** nothing if you want the tags. There is no correct answer; it depends which
you care about more.

If you want both — another mod's name *and* our tag — build from source with
`USE_WINNING_OVERRIDE = True` in `GenerateQuestMarkers.pas`. That copies the current winning record
and layers the tag onto whatever name is already there. The cost is that the other mod becomes a
master of your plugin, so the result is a personal build, not something to redistribute.

## Translations

The shipped plugins are English. If you play in another language, build from source: set
`USE_WINNING_OVERRIDE = True` with your translation loaded, and the tags will be prepended to the
translated names. The tag text itself is defined in one block at the top of
`GenerateQuestMarkers.pas` (`LoadTags`) and in `Database/aliases.json` — translate both, keeping the
strip list in `LoadTags` unchanged so old English tags are still recognised and removed.

## Save games

Safe to install mid-playthrough. `FULL` is read from the plugin at display time, not baked into the
save, so tags appear on quests you already have.

Safe to uninstall mid-playthrough. Names revert to vanilla. Nothing is scripted, so there is no
orphaned script data and no cleaning step.

## Missing DLC

The installer greys out any DLC module whose master is not present, and the conditional install
patterns additionally require the master to be active. A plugin with an unresolvable master cannot
be installed by following the installer.

If you install manually and get it wrong, the game will not load the plugin and xEdit will report a
missing master. `AuditQuests.pas` and `GenerateQuestMarkers.pas` both report missing masters rather
than producing a broken plugin.

## Creation Club plugins

The `NextGen` module masters whichever `cc*.esl` files are actually present, resolved at generation
time by filename pattern. Creation Club filenames are not stable across game versions, which is why
the database stores patterns like `cc*X02*.esl` rather than hardcoded names. If a pattern resolves
to nothing, that entry is reported as `NOMASTER` and skipped.

## Bethesda.net / console

Not supported. The build pipeline depends on xEdit, and the packaging targets Vortex and MO2.

## Known limitations

1. **Generated names.** Minutemen settlement quests display names built from `<Alias=Workshop>`
   tokens. The tag is prepended before the token, which works, but the resulting entry can be long
   in the descriptive style. Use the compact style if your Pip-Boy list looks cramped.
2. **Duplicate display names.** A few quests share a display name across several QUST records
   (Randolph Safehouse, Hull Breach and Butcher's Bill appear to have numbered variants). Name
   matching reports these as ambiguous and tags only the first. Adding the EditorIDs from
   `output/quests.candidate.tsv` resolves it.
3. **Timer detection is heuristic.** Timed classification is inferred from script property names.
   A mod that replaces a quest's script may change the result. Timed entries are never promoted past
   `likely` on that signal alone.
