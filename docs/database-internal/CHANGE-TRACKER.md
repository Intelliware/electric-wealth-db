# Change Tracker — Electric Wealth Database Documentation

### Header

| Field | Value |
|---|---|
| Artifact | Electric Wealth database RE documentation (Part A + Part B1 + Part B2) |
| Artifact type | Reverse-engineering package (database) |
| Current source version | `electric-wealth-db@05ff1a61e87f62666c0fceb35fc1604c1d7abccd`; schema `007_registration.sql`; package `0.1.0` |
| Current artifact version | `0.1.0-doc.1` |
| Stage / Skill of record | `reverse-engineer-database` |

### Versioning Convention

- `0.1.0-doc.1`: first revision for source version `0.1.0` (`package.json`) at schema `007`.
- `0.1.0-doc.2`: correction or addition for the same source version.
- `<next>-doc.1`: first revision after a new migration lands.

### Parts Affected — Reference

| Value | Meaning |
|---|---|
| A | Part A: internal DB docs (`electric-wealth-db/docs/database-internal/`) |
| B1 | Part B1: data dictionary + ERD (`electric-wealth-knowledge-base/source-docs/electric-wealth-db/data-dictionary.md`, `erd.mmd`) |
| B2 | Part B2: consumer guide (`…/source-docs/electric-wealth-db/database-consumer/`) |
| All | A + B1 + B2 |

### Change Types

Initial Extraction · Correction · Source Update · Restructure · Addition · Deprecation · Removal (universal; see `templates/blocks/shared/change-log.md`).

### Change Log

#### 0.1.0-doc.1 — 2026-10-15

| # | Date | Change Type | Parts Affected | Section / File | Description | Source Version | Verified |
|---|---|---|---|---|---|---|---|
| 4 | 2026-10-15 | Verified | A, B1, B2 | `verification-report.md` | RE close-out gate. Mode **automated**, chosen by the agent because the user was unavailable and delegated the choice (`re_verification_gate = "ask"`). | `05ff1a6` | automated (mechanical GO; 13 Tier M passed, 0 failed; 8 UNVERIFIED) |
| 3 | 2026-10-15 | Correction | A | `05-tables-detailed-documentation.md` (`offline_clients`) | Fixed an incorrect draft claim that registration never sets `offline_clients.enrolled_user_id`. It does (`RegistrationRepository.java:192`). | `05ff1a6` | ✅ |
| 2 | 2026-10-15 | Initial Extraction | B1, B2 | `data-dictionary.md`, `erd.mmd`, `database-consumer/01,02,04,05,06` | B1 data dictionary (35 tables, 241 columns) and column-level ERD (34 FK edges). B2 consumer guide (5 of 6 blocks; `working-with-stored-procedures` gated out). | `05ff1a6` | ✅ mechanical parity (see § Verification) |
| 1 | 2026-10-15 | Initial Extraction | A | `docs/database-internal/01–07, 12–23`, `extraction-status.md` | Part A internal docs (19 of 23 blocks; views / mat-views / sprocs / triggers gated out because none exist). | `05ff1a6` | ✅ mechanical parity (see § Verification) |

### Detailed Changes

#### Change #1 / #2

| Field | Value |
|---|---|
| Date | 2026-10-15 |
| Change Type | Initial Extraction |
| Parts Affected | All |
| Section / File | All files listed in `extraction-status.md` § 3 |
| Source Version | `05ff1a61e87f62666c0fceb35fc1604c1d7abccd` |

**Description:** first reverse-engineering pass over `migrations/001–007`, `seed/*`, `scripts/*`, and the live `data/electric-wealth.db`. The Spring API's repository layer was read to document consumer query patterns.

**Verification:** mechanical checks run during extraction:
- Column name, type and nullability parity: data dictionary vs `pragma_table_info` (241/241), ERD vs `pragma_table_info` (241/241), Part A § 5 coverage (241/241).
- Column default parity: data dictionary vs `pragma_table_info.dflt_value` (241/241).
- ERD edges vs `pragma_foreign_key_list`, including ON DELETE (34/34).
- No template placeholders remain.
- Consumer query patterns parsed with `EXPLAIN QUERY PLAN`.

**Cross-Impact:** none yet. The KB has not been built (`build-knowledge-base` pending).

### Cross-Part Synchronisation

| If this changes… | Check this… |
|---|---|
| A new migration (`migrations/NNN_*.sql`) | A §3 (ERD, stats), §5, §6.3 FK list, §6.5 CHECKs, §7.2 indexes, §15.2 history; B1 dictionary + `erd.mmd`; B2 query patterns |
| Seed files | A §14; B2 §19.3 demo data table |
| `scripts/lib.js` (runner, pragmas, path resolution) | A §2, §13, §15; B2 §19.1 |
| API `DatabaseConfig` / `application.yml` (JDBC URL, pool) | A §2, §13; B2 §19.1, §22 |
| API repository SQL | B2 §20 (query patterns), §22 (transactions), §23 (errors) |
