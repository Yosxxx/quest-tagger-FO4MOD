# Pip-Boy Quest Tagger for Fallout 4

[![Fallout 4](https://img.shields.io/badge/Fallout%204-1.11.240%2B-blue.svg)](https://bethesda.net/game/fallout-4)
[![Mod Version](https://img.shields.io/badge/Version-1.1.0-brightgreen.svg)](https://www.nexusmods.com/fallout4/mods)
[![Format](https://img.shields.io/badge/Format-ESL--flagged%20ESP-orange.svg)](#)
[![Mod Manager](https://img.shields.io/badge/Installer-2--Step%20FOMOD-purple.svg)](#installation)

Tells you at a glance in your Pip-Boy quest log which quests are main storyline milestones, faction endings, side quests, Creation Club content, or repeatable radiants.

```text
[Main] War Never Changes
[Institute - Main] Synth Retention
[Side Quest] Boston After Dark
[Creation Club] Echoes of the Past
[Radiant] Cleansing the Commonwealth
[Defend] Defend the Castle
[Timed] Kidnapping at Finch Farm
```

---

## Features

- **Instant Recognition:** Distinguish one-time authored story quests from endless repeatable radiants at a glance.
- **Two Distinct Tagging Styles:**
  - **Descriptive (Recommended):** Full, immersive words like [Main], [Side Quest], [Creation Club], and [Minutemen - Main].
  - **Compact:** Clean, minimal bracketed symbols ([M], [S], [CC], [R], [D], [T]).
- **FallUI & FIS Safe:** Faction endgame paths use - Main (e.g. [Minutemen - Main], [Institute - Main]), preventing inventory sorting UI mods from turning quest names into generic faction icons.
- **Zero Script Bloat:** 100% pure override plugins (modifying only QUST \ FULL - Name). No scripts, no scripts extender required, no risk of savegame corruption.
- **100% ESL-Flagged:** Takes 0 slots against your 254 ESP/ESM plugin limit.
- **2-Step Modular FOMOD Installer:** Step 1 picks your visual style; Step 2 lets you select which quest categories to tag. Includes live visual previews in Vortex and Mod Organizer 2.

---

## Tag Legend

| Category | Descriptive Style (Default) | Compact Style | Example |
| :--- | :--- | :--- | :--- |
| **Main Story** | [Main] | [M] | [Main] Institutionalized |
| **Minutemen Endgame** | [Minutemen - Main] | [MM] | [Minutemen - Main] When Freedom Calls |
| **Railroad Endgame** | [Railroad - Main] | [RR] | [Railroad - Main] Tradecraft |
| **Institute Endgame** | [Institute - Main] | [Inst] | [Institute - Main] Synth Retention |
| **Brotherhood Endgame** | [BoS - Main] | [BoS] | [BoS - Main] Blind Betrayal |
| **Side Quests** | [Side Quest] | [S] | [Side Quest] Confidence Man |
| **Repeatable Radiants** | [Radiant] | [R] | [Radiant] Quartermastery |
| **Settlement Defense** | [Defend] | [D] | [Defend] Raider Troubles |
| **Timed Kidnappings** | [Timed] | [T] | [Timed] Kidnapping at Finch Farm |
| **DLC Campaigns** | [Far Harbor] / [Nuka-World] / etc. | [DLC] | [Far Harbor] Rite of Passage |
| **Creation Club / Next-Gen** | [Creation Club] | [CC] | [Creation Club] Echoes of the Past |

---

## Installation

Install using **Vortex** or **Mod Organizer 2**:

1. Download the archive (RadiantQuestMarker.zip) and click **Install**.
2. **Step 1: Choose Style** - Select **Descriptive** (recommended) or **Compact**. Visual screenshots are previewed in the installer pane.
3. **Step 2: Choose Categories** - Select which modules you want active:
   - Main Story & Faction Paths
   - Side Quests
   - Repeatable Radiant Quests
   - Settlement Defense Alerts
   - Timed Kidnappings & Rescues
   - Official DLCs (Far Harbor, Nuka-World, Automatron, Vault-Tec)
   - Creation Club / Next-Gen Quests
4. Enable the plugins in your load order.

---

## Compatibility

- **Next-Gen Update:** Fully compatible with Fallout 4 runtime 1.11.240 and later.
- **FallUI & DEF_UI:** Compatible. Descriptive mode uses - Main on faction quests so UI mods will not replace names with icon glyphs.
- **Unofficial Fallout 4 Patch (UFO4P):** Compatible. Quest records preserve all baseline naming conventions.
- **Safe to Install / Uninstall Mid-Playthrough:** Since only quest display names are touched, you can install, switch styles, or remove the mod at any point without impacting quest logic or script variables.

---

## Repository Structure

`	ext
├── Database/               # Source databases and alias dictionaries
│   ├── aliases.json        # Style tagging definitions and strip tables
│   ├── quests.json         # Master quest database with confidence ratings
│   └── radiant_rules.json  # Story manager and repeatable logic classification
├── Documentation/          # Technical specifications and compatibility guides
│   ├── COMPATIBILITY.md
│   ├── IMPLEMENTATION.md
│   └── QUEST_DATABASE.md
├── fomod/                  # Vortex & Mod Organizer 2 FOMOD installer
│   ├── images/             # Screenshot previews for options
│   └── ModuleConfig.xml    # 2-step installer script
├── Plugins/                # Modular ESL-flagged plugin trees
│   ├── Compact/
│   └── Descriptive/
├── Scripts/                # xEdit / FO4Edit Pascal build and audit scripts
│   ├── AuditQuests.pas
│   ├── GenerateQuestMarkers.pas
│   └── ValidateQuestMarkers.pas
└── package.py              # Build and distribution packaging script
`

---

## Building from Source

Requirements: Python 3.9+ and FO4Edit 4.1.5+.

1. Run Pascal generator in FO4Edit:
   - Open Fallout4.esm and DLC masters in FO4Edit.
   - Apply script Scripts/GenerateQuestMarkers.pas.
2. Build distribution archive:
   `ash
   python package.py
   `
   Outputs a release archive in dist/RadiantQuestMarker-<version>.zip.

---

## License

MIT License. Quest names and Fallout 4 assets are property of Bethesda Softworks.
