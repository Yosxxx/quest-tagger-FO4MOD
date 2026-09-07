# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

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
