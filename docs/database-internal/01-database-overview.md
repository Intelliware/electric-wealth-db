---
slug: database-overview
title: "Database Overview"
part: A
source-repo: electric-wealth-db
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
schema-version: 007_registration.sql
extracted: 2026-10-15
---

## 1. Database Overview

### 1.1 What This Database Is

- **Name:** Electric Wealth database (`electric-wealth-db`), file `data/electric-wealth.db`
- **DBMS:** SQLite 3, single file. Built by Node.js 24's built-in `node:sqlite` module (`scripts/lib.js`). Read and written at runtime by the Spring API through `org.xerial:sqlite-jdbc` 3.53.4.0. The CLI used for this extraction reported `sqlite_version()` = 3.51.0.
- **Purpose:** The backend data store for Electric Wealth v2, a retail wealth-management portal. It holds users and auth sessions, investment accounts (holdings, transactions, performance), documents, goals and dashboard content, notifications, the learning centre, advisor meetings and messages, static market data and watchlists, and online enrolment (registration) for existing branch clients.
- **Environment:** Local or workshop only. The repo builds one database file on a developer machine from migrations plus demo seed data (6 personas). No staging or production environment is defined anywhere in the source.

### 1.2 Database Architecture

- **Architecture style:** Embedded, file-based, single-schema OLTP store. The schema is owned by this repo. The Spring API (`electric-wealth-api-spring`) connects to the same file and "never creates or migrates tables" (`DatabaseConfig.java`).
- **Scaling strategy:** Single instance, single file. No replicas, sharding or connection server. The API uses a HikariCP pool of at most 4 connections (`application.yml`: `spring.datasource.hikari.maximum-pool-size: 4`).
- **Key characteristics:**
  - **Tenant-scoped composite keys.** Most per-user tables use a primary key that starts with `user_id`, because business ids (`'tfsa'`, `'d1'`, `'goal-1'`) are only unique per user.
  - **Money stored as INTEGER minor units (cents)**, always next to a `currency` TEXT column.
  - **Booleans as INTEGER 0/1** with `CHECK (col IN (0, 1))`; enumerations as TEXT with `CHECK (col IN (...))`.
  - **Dates and times as ISO-8601 TEXT in UTC**, except the advisor appointment `date`/`time`, which are Toronto local time.
  - **Hard deletes with `ON DELETE CASCADE`** from `users`. There are no soft-delete columns.
  - **No views, triggers or stored procedures.** All business logic lives in the API.

### 1.3 Design Philosophy

| Decision | Rationale (from source comments) |
|----------|-----------|
| Composite primary keys starting with `user_id` | "Business ids (account 'tfsa', document 'd1', ...) are only unique per user, so most tables use a composite primary key that starts with user_id." (`001_initial_schema.sql` header) |
| Money in minor units (INTEGER) plus ISO-4217 `currency` | Avoids floating-point rounding on balances and amounts (`001_initial_schema.sql` conventions). |
| Booleans as INTEGER 0/1 | SQLite has no boolean type (`001_initial_schema.sql`; `SqlValues.toInt`). |
| ISO-8601 TEXT timestamps in UTC | Sorts lexically in time order and is portable between the Node scripts and the Java API. |
| Bilingual columns (`*_en` / `*_fr`) for catalogue text | "The API picks one from the request's Accept-Language header." (`004_education.sql`) |
| Demo-only plain-text secrets (`users.password`, `users.mfa_code`, `registrations.password`) | Explicitly marked "demo only … never do this for real". This is a workshop dataset, not a production design. |
| Schema owned by this repo; API is read/write only | `DatabaseConfig.java` refuses to start if the file is missing and never runs DDL. |
| Portfolio total value is derived, not stored | "Total value is computed by the API from visible account balances." (`001_initial_schema.sql`, `portfolio_snapshots`) |

### 1.4 Key Statistics

Measured on 2026-10-15 against `data/electric-wealth.db` built from commit `05ff1a6`.

| Metric | Value | Notes |
|--------|-------|-------|
| **Database size** | 450,560 bytes (~440 KB) | `page_count × page_size` |
| **Application tables** | 34 | Plus `schema_migrations` (migration ledger) and `sqlite_sequence` (SQLite internal) |
| **Largest tables** | `price_history` (408 rows), `transactions` (216), `performance_points` (189) | Seed data only |
| **Users** | 6 seeded personas | `sarah`, `michael`, `linda`, `david`, `emma`, `foster` |
| **Read / write rate** | Not measured | No telemetry exists; single-developer local use |
| **Backup schedule** | None | The file is git-ignored and rebuilt with `npm run db:reset` |
| **Availability SLA** | None | Local development database |
