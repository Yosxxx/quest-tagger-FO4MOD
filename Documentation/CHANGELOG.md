# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.2.0] - 2026-09-10

### Added / Changed
- Recategorized entire mod classification scheme based on the Fallout 4 Quest Flowchart.
- Implemented comprehensive 11-tag hierarchy across both styles:
  - **MAIN**: `[M]` / `[Main]`
  - **BROTHERHOOD OF STEEL**: `[BOS]` / `[Brotherhood of Steel]`
  - **INSTITUTE**: `[INST]` / `[Institute]`
  - **MINUTEMEN**: `[MM]` / `[Minutemen]`
  - **RAILROAD**: `[RR]` / `[Railroad]`
  - **BROTHERHOOD SIDE QUEST**: `[BOS-S]` / `[Brotherhood Side Quest]`
  - **INSTITUTE SIDE QUEST**: `[INST-S]` / `[Institute Side Quest]`
  - **MINUTEMEN SIDE QUEST**: `[MM-S]` / `[Minutemen Side Quest]`
  - **RAILROAD SIDE QUEST**: `[RR-S]` / `[Railroad Side Quest]`
  - **SIDE QUEST**: `[S]` / `[Side Quest]` (Vault 81 strictly preserved as Side Quest)
  - **RADIANT**: `[R]` / `[Radiant]` (including settlement defense and timed attacks)
- Reassigned Railroad repeatable missions (`Weathervane`, `Jackpot`, `Randolph Safehouse`, `To the Mattresses`, `Butcher's Bill`, `Mercer Safehouse`, `Lost Soul`) to Railroad Side Quests (`[RR-S]`).
- Reassigned Proctor Quinlan / Ingram / Neriah research objectives (`BoSFFMaster`) to Brotherhood Side Quest (`[BOS-S]`).
- Rebuilt plugins to maintain 100% disjoint overrides between modules with zero FormID collisions.
- Resolved all missing vanilla string IDs directly from `Fallout4.esm` string tables.

## [1.1.1] - 2026-09-10

### Fixed
- Restored vanilla `DNAM\Type` categories across all plugins (Railroad, Brotherhood of Steel, Institute, Minutemen, Side). Radiant quests are no longer forced into Pip-Boy `Miscellaneous`.
- Fixed Tinker Tom's MILA quest (`Weathervane` / `RRR05`), Railroad Dead Drops (`Jackpot` / `RRR03`), and other radiant quests being hidden in the Miscellaneous quest group with missing location names.
- Restored dynamic quest location tokens (`<Alias=QuestLocation>`, `<Alias=Dungeon>`, `<Global=DisplayNumber>`) which now display properly in the main Pip-Boy log.
- Updated `Scripts/GenerateQuestMarkers.pas` to set `RADIANTS_TO_MISC = False` and removed forced `DNAM\Type` override logic.

## [1.1.0] - 2026-09-07

### Added
- Streamlined 2-step FOMOD installer (Style Selection -> Module Customization).
- Visual preview cards in installer for Descriptive and Compact modes.
- Descriptive tag polish: `[Main]` for main questline, `[Side Quest]` for side quests, `[Faction - Main]` for faction finales.

## [1.0.0] - unreleased

First build. Framework, database and tooling are complete; the database has not yet been verified
against a real installation, so this is not release-ready as-is. See "Verification status" below.

### Added
- Quest database (`Database/quests.json`) with 53 entries across four confidence states, an
  `evidence` field per entry, and separate source / faction / behaviour axes.
- Rule engine (`Database/radiant_rules.json`) with weighted record-level signals, hard exclusions
  and EditorID family patterns for the Minutemen settlement quests.
- Tag vocabulary (`Database/aliases.json`) for both descriptive and compact styles, plus the
  longest-first strip list.
- `Scripts/AuditQuests.pas` — read-only discovery pass. Classifies QUST records from Story Manager
  references and quest flags, resolves FormIDs and EditorIDs, and is the only component permitted to
  write confidence `verified`.
- `Scripts/GenerateQuestMarkers.pas` — override generator. Touches only `QUST \ FULL - Name`.
  Idempotent, style-switchable, with `DRY_RUN` and `USE_WINNING_OVERRIDE` modes.
- `Scripts/ValidateQuestMarkers.pas` — post-build proof that no field outside `FULL` differs from the
  master, that exactly one tag is present, and that each plugin is ESL-valid.
- `build/package.py` — generates `quests.tsv`, `QUEST_DATABASE.md`, `fomod/ModuleConfig.xml`
  (18 conditional install patterns) and `fomod/info.xml`, then packages the archive.
- Four-page FOMOD: content selection, per-DLC picker, tag style, special categories. DLC options are
  `NotUsable` when their master is missing.
- Nine disjoint modules so installer toggles never produce two plugins overriding the same quest.
- Documentation set: README, QUEST_DATABASE, IMPLEMENTATION, COMPATIBILITY, this file.

### Verification status
- `verified` entries: **0**. Verification requires reading QUST records in a real installation.
- `likely`: 22 (tagged by default)
- `unverified`: 10 (not tagged unless `ALLOW_UNVERIFIED` is enabled)
- `excluded`: 11 (never tagged, reasons documented)
- Every `formID` and `editorID` column is null pending the audit pass.

### Not done
- No plugins are shipped. `Plugins/` contains the folder tree and placeholders only.
- Minutemen settlement quest families are defined as rules, not enumerated entries. The audit
  materialises them.
- `Documentation/QUEST_DATABASE.md` is generated and will change substantially after the first audit.
