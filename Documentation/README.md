# Radiant Quest Marker

Tells you at a glance which quests in your Pip-Boy log are recurring and which are one-time content.

```
Cleansing the Commonwealth      ->  [Brotherhood - Radiant] Cleansing the Commonwealth
Blood Tide                      ->  [Far Harbor - Radiant] Blood Tide
Quartermastery                  ->  [Brotherhood - Radiant] Quartermastery
```

## What it does

Fallout 4 issues a lot of quests procedurally through the Story Manager. They look identical to
hand-authored story and side quests in the quest log, so it is easy to spend an evening on something
the game will hand you again next week, or to skip a one-time quest thinking it will come back.

This mod prefixes recurring quests with a descriptive tag. That is the whole mechanism.

## What it does not do

It does not remove, disable, block or fail radiant quests. You still receive every quest you would
have received. Scripts, stages, objectives, aliases, conditions, rewards and dialogue are untouched —
the plugins override exactly one subrecord per quest, `QUST \ FULL - Name`. `ValidateQuestMarkers.pas`
checks this and will fail the build if anything else drifts.

## Requirements

- Fallout 4 PC, runtime 1.11.240 (18 August 2026 update) or later
- Whichever official DLC you want covered. Missing DLC simply means that module is not installed.
- No script extender, no UI framework, no font replacer.

## Installation

Install the archive through Vortex or MO2 and answer four questions.

| Page | Default |
| --- | --- |
| Quest Content | Vanilla + DLC |
| DLC Modules (only if you chose "Pick DLC manually") | — |
| Quest Tag Style | Descriptive |
| Special Categories | Timed + Settlement |

Modules whose master is missing are greyed out in the installer and excluded from the install, so
you cannot end up with a plugin that has an unresolvable master.

## Tag legend

### Descriptive (default)

| Tag | Meaning |
| --- | --- |
| `[Radiant]` | Recurring, no specific faction |
| `[Minutemen - Radiant]` | Recurring Minutemen quest |
| `[Brotherhood - Radiant]` | Recurring Brotherhood of Steel quest |
| `[Railroad - Radiant]` | Recurring Railroad quest |
| `[Institute - Radiant]` | Recurring Institute quest |
| `[Far Harbor - Radiant]` | Recurring Far Harbor quest |
| `[Nuka-World - Radiant]` | Recurring Nuka-World quest |
| `[Automatron - Radiant]` | Recurring Automatron quest |
| `[Vault-Tec - Radiant]` | Recurring Vault-Tec Workshop quest |
| `[Settlement - Radiant]` | Recurring settlement quest, no single faction |
| `[Timed - Radiant]` | Recurring **and** fails after a time limit |
| `[Settlement - Establishment]` | Sets up or unlocks a settlement |
| `[Minutemen - Settlement Defense]` | Recurring threat against a settlement you own |
| `[Next-Gen]` | Arrived with the Next-Gen update / Creation Club |

### Compact

| Tag | Meaning | | Tag | Meaning |
| --- | --- | --- | --- | --- |
| `[R]` | Radiant | | `[R-NW]` | Nuka-World radiant |
| `[R-MM]` | Minutemen radiant | | `[R-AT]` | Automatron radiant |
| `[R-BOS]` | Brotherhood radiant | | `[R-VW]` | Vault-Tec radiant |
| `[R-RR]` | Railroad radiant | | `[R-SET]` | Settlement radiant |
| `[R-INT]` | Institute radiant | | `[T]` | Timed radiant |
| `[R-FH]` | Far Harbor radiant | | `[S]` | Settlement establishment |
| `[MM-DEF]` | Settlement defence | | `[NG]` | Next-Gen / Creation Club |

Plain ASCII throughout. Nothing here needs a special font.

## `[Next-Gen]` is a source label, not a behaviour label

A quest is not radiant because the Next-Gen update added it. Speak of the Devil, Best of Three and
the Enclave Remnants questline are one-time content that happens to ship with the modern game
distribution, and they are tagged `[Next-Gen]`, never `[Radiant]`. Source, faction and behaviour are
three separate axes in the database, which is why `[Brotherhood - Radiant]` exists as a combination
rather than forcing a choice between "Brotherhood" and "Radiant".

## Honest scope

The shipped database labels every entry with a confidence state, and the default install tags only
`verified` and `likely` entries. `unverified` entries are listed in `QUEST_DATABASE.md` but are not
tagged unless you opt in. `excluded` entries are quests that were reviewed and deliberately left
alone — Mercer Safehouse, Home Sweet Home and The First Step all involve settlements and none of
them are radiant.

**Nothing ships as `verified`.** Verification requires reading the QUST records in a real
installation. `Scripts/AuditQuests.pas` does exactly that and is the only thing permitted to write
that value. If you are building from source, run it first. See `IMPLEMENTATION.md`.

The Minutemen settlement quests are handled by EditorID family rather than by name, because their
display names contain text-replacement tokens like `<Alias=Workshop>` and the string a player sees
is generated per settlement.

## Known conflicts

Any other mod that edits the same quest's display name will conflict — last plugin loaded wins.
See `COMPATIBILITY.md`.

## Credits

Independent implementation. Functionality is inspired by the Radiant Quest Marker mod on Nexus
(mod 20401), but no code, assets, records or plugins from that project were used or copied. The
database, rule engine, scripts, installer and documentation here are original work.
