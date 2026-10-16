# Extraction Status — electric-wealth-db

| Field | Value |
|---|---|
| Skill | `reverse-engineer-database` |
| Repo | `electric-wealth-db` (role: database, type: sqlite-node-sql-migrations) |
| Source commit | `05ff1a61e87f62666c0fceb35fc1604c1d7abccd` (HEAD, "Document Spring API database setup") |
| Schema version | `007_registration.sql` (7 of 7 migrations applied) |
| Engine | SQLite 3. Built by Node 24 `node:sqlite`; runtime via `sqlite-jdbc` 3.53.4.0; inspected with sqlite3 CLI 3.51.0 |
| Extraction date | 2026-10-15 |
| Part A path | `electric-wealth-db/docs/database-internal/` |
| Part B path | `electric-wealth-knowledge-base/source-docs/electric-wealth-db/` (`database-consumer/`, `data-dictionary.md`, `erd.mmd`) |
| Overall status | **Extraction complete. Close-out: automated, MECHANICAL: GO** (13 Tier M passed, 0 failed; 8 UNVERIFIED). See `verification-report.md`. |

## 1. Inventory

| Artifact type | Count | Items | Documented in |
|---|---|---|---|
| Application tables | 34 | see § 2 | A §5, B1 data dictionary, ERD |
| Infrastructure tables | 2 | `schema_migrations` (documented), `sqlite_sequence` (SQLite internal; mentioned only) | A §5.J, B1 |
| Columns (incl. `schema_migrations`) | 241 | from `pragma_table_info` | A §5, B1, ERD |
| Foreign keys | 34 | 25 CASCADE, 9 NO ACTION; all ON UPDATE NO ACTION | A §6.3 (full list), B1, ERD (34 edges) |
| Explicit indexes | 7 | `ix_sessions_user`, `ix_transactions_account_date`, `ix_notifications_user_created`, `ix_document_shares_document`, `ix_appointments_user`, `ux_appointments_advisor_slot` (partial unique), `ix_advisor_messages_user` | A §7.2 |
| Automatic indexes | 36 | `sqlite_autoindex_*` (PK/UNIQUE) | A §3.3, §5 |
| CHECK constraints | 34 | 11 boolean, 21 enumeration, 2 range | A §6.5, B1 |
| Views | 0 | — | gate: omitted |
| Materialized views | 0 | — | gate: omitted |
| Stored procedures / functions | 0 | SQLite has none | gate: omitted (A and B) |
| Triggers | 0 | — | gate: omitted |
| Migration files | 7 | `001`–`007` | A §15 |
| Seed files | 11 | `001`–`006` personas, `102`/`104`/`105`/`106`/`107` | A §14 |
| Scripts | 5 | `lib.js`, `migrate.js`, `seed.js`, `reset.js`, `status.js` | A §2, §13, §15 |

FK map complete: **yes** (verified with `pragma_foreign_key_list` across every table).

## 2. Table Coverage

| Table | Migration | A §5 | B1 dictionary | ERD |
|---|---|---|---|---|
| users | 001 (+005, +007) | ✅ | ✅ | ✅ |
| user_profiles | 001 | ✅ | ✅ | ✅ |
| user_preferences | 001 | ✅ | ✅ | ✅ |
| sessions | 001 | ✅ | ✅ | ✅ |
| accounts | 001 | ✅ | ✅ | ✅ |
| holdings | 001 | ✅ | ✅ | ✅ |
| transactions | 001 | ✅ | ✅ | ✅ |
| account_performance | 001 | ✅ | ✅ | ✅ |
| performance_points | 001 | ✅ | ✅ | ✅ |
| documents | 001 | ✅ | ✅ | ✅ |
| goals | 001 | ✅ | ✅ | ✅ |
| portfolio_snapshots | 001 | ✅ | ✅ | ✅ |
| asset_allocations | 001 | ✅ | ✅ | ✅ |
| alerts | 001 | ✅ | ✅ | ✅ |
| quick_links | 001 | ✅ | ✅ | ✅ |
| notifications | 002 | ✅ | ✅ | ✅ |
| document_shares | 003 | ✅ | ✅ | ✅ |
| education_content | 004 | ✅ | ✅ | ✅ |
| education_progress | 004 | ✅ | ✅ | ✅ |
| glossary_terms | 004 | ✅ | ✅ | ✅ |
| advisors | 005 | ✅ | ✅ | ✅ |
| appointments | 005 | ✅ | ✅ | ✅ |
| advisor_messages | 005 | ✅ | ✅ | ✅ |
| securities | 006 | ✅ | ✅ | ✅ |
| price_history | 006 | ✅ | ✅ | ✅ |
| watchlist | 006 | ✅ | ✅ | ✅ |
| market_news | 006 | ✅ | ✅ | ✅ |
| market_roundup_items | 006 | ✅ | ✅ | ✅ |
| baskets | 006 | ✅ | ✅ | ✅ |
| offline_clients | 007 | ✅ | ✅ | ✅ |
| security_questions | 007 | ✅ | ✅ | ✅ |
| registrations | 007 | ✅ | ✅ | ✅ |
| registration_security_answers | 007 | ✅ | ✅ | ✅ |
| user_security_answers | 007 | ✅ | ✅ | ✅ |
| schema_migrations | `scripts/lib.js` | ✅ | ✅ | ✅ |

## 3. Composition Block Rendering

Decision gates were evaluated from the inventory. `project.toml [project.elicitation]` does not define `has_views` / `has_materialized_views` / `has_stored_procedures` / `has_triggers`, so they evaluate to false, which matches the source.

### Part A — `re-database-internal` (23 blocks → 19 rendered)

| # | Block | Status |
|---|---|---|
| 01 | database-overview | ✅ |
| 02 | environment-and-configuration | ✅ |
| 03 | schema-overview-and-erd | ✅ |
| 04 | naming-conventions | ✅ |
| 05 | tables-detailed-documentation | ✅ |
| 06 | constraints-and-integrity | ✅ |
| 07 | indexes-and-performance | ✅ |
| 08 | views | ⛔ gated out (`has_views` = false) |
| 09 | materialization-and-refresh-strategy | ⛔ gated out (`has_materialized_views` = false) |
| 10 | stored-procedures-and-functions | ⛔ gated out (`has_stored_procedures` = false) |
| 11 | triggers | ⛔ gated out (`has_triggers` = false) |
| 12 | security-and-access-control | ✅ |
| 13 | authentication-and-connection | ✅ |
| 14 | reference-and-seed-data | ✅ |
| 15 | migrations-and-versioning | ✅ |
| 16 | backup-and-recovery | ✅ |
| 17 | data-retention-and-archival | ✅ |
| 18 | monitoring-and-performance-baselines | ✅ |
| 19 | anti-patterns-and-pitfalls | ✅ |
| 20 | new-table-checklist | ✅ |
| 21 | glossary-and-data-definitions | ✅ |
| 22 | code-examples | ✅ |
| 23 | faq-and-troubleshooting | ✅ |

### Part B — `re-database-consumer` (6 blocks → 5 rendered)

| # | Block | Status |
|---|---|---|
| 01 | how-to-query-this-database | ✅ |
| 02 | common-query-patterns | ✅ |
| 03 | working-with-stored-procedures | ⛔ gated out (`has_stored_procedures` = false) |
| 04 | transactions-and-concurrency | ✅ |
| 05 | error-handling-and-recovery | ✅ |
| 06 | performance-guidelines-for-developers | ✅ |

### Supplementary (Part B1)

| Artifact | Status |
|---|---|
| `data-dictionary.md` | ✅ |
| `erd.mmd` | ✅ |

## 4. Scope Notes and Assumptions

- **Scaffold approval:** the session ran in autopilot. The file structure is fixed by the composition block lists, so it was applied as-is rather than presented for approval.
- **Runtime consumers** were read only to document *how the schema is used* (`electric-wealth-api-spring` repositories and `DatabaseConfig`). They are not in scope for this extraction.
- **KB repo:** `electric-wealth-knowledge-base/` did not exist and was created at the `knowledge_base_path` declared in `project.toml`. It contains only this repo's source-docs; `build-knowledge-base` has not run.
- **Behavioural claims verified on a throwaway copy** (`sqlite3 .backup`):
  - User delete is blocked by `offline_clients.enrolled_user_id`.
  - The cascade works once that link is cleared.
  - Partial-unique slot violation text.
  - CHECK violation text.
  - `email` NOCASE match.
- **Query plans** were captured with `EXPLAIN QUERY PLAN` on the live file (read-only).

## 5. Open Items

None blocking. Observations worth tracking (not defects in the extraction):
1. Plain-text passwords, security answers and MFA codes (demo by design).
2. `sessions` and `registrations` grow without bound (no purge).
3. Several FK child columns have no index (§7.4).
4. `registrations.trusted_contact_phone`/`email` are not persisted to `user_profiles`.
5. The migration runner has no checksum or down migrations; the runner's `PRAGMA foreign_keys = ON` blocks table-rebuild migrations from disabling FKs.
