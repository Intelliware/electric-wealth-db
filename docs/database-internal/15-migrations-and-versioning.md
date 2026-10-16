---
slug: migrations-and-versioning
title: "Migrations and Versioning"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 15. Migrations and Versioning

### 15.1 Migration Strategy

Schema changes are **forward-only, plain-SQL migration files** applied by a small custom runner. There is no Flyway, Liquibase or Knex.

**Migration file format:** `NNN_<description>.sql` (three-digit, zero-padded sequence).
**Location:** `migrations/`.
**Tool:** custom, `scripts/lib.js migrate()`, run by `npm run db:migrate` (also called by `db:reset`).
**Ledger:** table `schema_migrations(version TEXT PK, applied_at TEXT)`, created by the runner with `CREATE TABLE IF NOT EXISTS`.

**Runner algorithm (`scripts/lib.js`):**
1. Open the DB with `PRAGMA foreign_keys = ON`.
2. Ensure `schema_migrations` exists.
3. Read the applied `version`s; list `migrations/*.sql` sorted by **file name**.
4. For each file not yet applied: `BEGIN` → `db.exec(fileSql)` → `INSERT INTO schema_migrations(version) VALUES (<file name>)` → `COMMIT`. On error: `ROLLBACK` and rethrow, which stops the run.

**Properties and limitations:**

| Property | Behaviour |
|---|---|
| Atomicity | One transaction **per migration file**. A failed file leaves no partial DDL (SQLite DDL is transactional) and no ledger row. |
| Ordering | Lexical file-name sort. It relies on zero-padding: a file named `10_x.sql` would sort before `2_x.sql`. |
| Change detection | **None.** The ledger stores only the file name; there is no checksum. Editing an applied migration has **no effect** on existing databases and is not detected. |
| Rollback / down migrations | **None.** Recovery is `npm run db:reset` (drop the file and rebuild). |
| Concurrency | No lock beyond SQLite's own write lock. Do not run `migrate` while the API is writing. |
| Who runs it | Developers only. The Spring API never migrates. |

### 15.2 Migration History

| Version | Commit | Changes |
|---|---|---|
| `001_initial_schema.sql` | `86810e1` Initial schema, seed data and setup scripts | 15 tables: identity, accounts, documents, goals, dashboard; indexes `ix_sessions_user`, `ix_transactions_account_date` |
| `002_notifications.sql` | `f9b52c0` | `notifications` + `ix_notifications_user_created` |
| `003_document_shares.sql` | `116f5d3` | `document_shares` (AUTOINCREMENT) + `ix_document_shares_document` |
| `004_education.sql` | `44314c3` | `education_content`, `education_progress`, `glossary_terms` |
| `005_advisor.sql` | `c6aeaa3` | `advisors`, `appointments`, `advisor_messages`; `ALTER TABLE users ADD COLUMN advisor_id`; `ix_appointments_user`, `ux_appointments_advisor_slot`, `ix_advisor_messages_user` |
| `006_market.sql` | `ea587af` | `securities`, `price_history`, `watchlist`, `market_news`, `market_roundup_items`, `baskets` |
| `007_registration.sql` | `ea98ded` | `offline_clients`, `security_questions`, `registrations`, `registration_security_answers`, `user_security_answers`; `ALTER TABLE users ADD COLUMN mfa_method … DEFAULT 'sms' CHECK (…)`, `ADD COLUMN terms_accepted_at` |

Current schema version: **`007_registration.sql`** (repo HEAD `05ff1a6`).

### 15.3 Naming Conventions in Migrations

- **New tables:** `CREATE TABLE <plural_snake> (...)` with inline constraints. Do not name constraints (§ 4.3).
- **Add column:** `ALTER TABLE <t> ADD COLUMN <c> <type> [NOT NULL DEFAULT <v>] [CHECK (...)] [REFERENCES ...]`. SQLite requires a non-NULL default for `NOT NULL` columns. A `REFERENCES` clause on an added column must have a NULL default (as `users.advisor_id` does).
- **Indexes:** `CREATE [UNIQUE] INDEX ix_|ux_<table>_<purpose> ON <t>(...) [WHERE ...]`.
- **SQLite limitations to plan around:** `ALTER TABLE` cannot change a column's type, constraint, CHECK or FK, and cannot drop a column that is indexed or constrained. Those changes need the **12-step table rebuild**: create `new_t`, `INSERT INTO new_t SELECT …`, `DROP TABLE t`, `ALTER TABLE new_t RENAME TO t`, then recreate indexes. Run `PRAGMA foreign_keys = OFF` around it. **However, the runner turns FKs ON before opening the transaction, and `PRAGMA foreign_keys` is a no-op inside a transaction.** A rebuild migration must therefore use `PRAGMA defer_foreign_keys = ON` or keep its parent and child tables consistent; the runner cannot disable FKs for it.

### 15.4 Example Migration (house style, based on 005)

```sql
-- 008_<description>.sql
-- One or two lines on what and why (every existing migration starts with this header).

CREATE TABLE things (
    user_id     TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id          TEXT    NOT NULL,
    kind        TEXT    NOT NULL CHECK (kind IN ('a', 'b')),
    amount      INTEGER NOT NULL,          -- minor units
    currency    TEXT    NOT NULL,
    archived    INTEGER NOT NULL DEFAULT 0 CHECK (archived IN (0, 1)),
    created_at  TEXT    NOT NULL,
    PRIMARY KEY (user_id, id)
);

CREATE INDEX ix_things_user_created ON things(user_id, created_at DESC);

-- NULL = not set yet.
ALTER TABLE users ADD COLUMN favourite_thing_id TEXT;
```

Then add `seed/108_things.sql` for demo data, and `npm run db:reset`.
