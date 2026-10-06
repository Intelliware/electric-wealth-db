# electric-wealth-db

The database for **Electric Wealth**, a Canadian retail wealth-management web app. This repo owns the schema (migrations), the demo seed data, and the scripts that build the database.

It uses **SQLite** through Node's built-in `node:sqlite` module, so you don't need Docker, a database server, admin rights, or even `npm install`.

| Repo | Role |
|---|---|
| **electric-wealth-db** (this repo) | Schema, migrations, seed data |
| electric-wealth-api | REST API that reads and writes this database |
| electric-wealth-web | Browser app that calls the API |

## Getting started (Windows, macOS, Linux)

Prerequisite: **Node.js 22.13 or later** (`node --version`).

```bash
npm run db:reset     # delete and rebuild data/electric-wealth.db from migrations + seed
npm run db:status    # show applied migrations and row counts
```

That's it. The API expects the database at `../electric-wealth-db/data/electric-wealth.db`, which is the default location, so clone the three repos side by side.

| Script | What it does |
|---|---|
| `npm run db:reset` | Deletes the database file, then runs every migration and loads all seed data |
| `npm run db:migrate` | Applies only the migrations that haven't been applied yet |
| `npm run db:seed` | Loads seed data into an empty database (skips if users already exist; `-- --force` to override) |
| `npm run db:status` | Lists migrations (applied or pending) and row counts per table |

To use a different file, pass `--db <path>` or set `DB_PATH`:

```bash
npm run db:reset -- --db C:\temp\ew-test.db
```

> **Stop the API before running `db:reset`.** On Windows, an open connection locks the file.

## Layout

```
migrations/   NNN_description.sql   schema changes, applied in filename order
seed/         NNN_<persona>.sql     demo data, one file per persona
scripts/      migrate / seed / reset / status (plain Node, no dependencies)
data/         electric-wealth.db    generated, git-ignored
```

## Conventions

- **Money** is stored in minor units (cents) as `INTEGER`, with an ISO currency code (`CAD`).
- **Booleans** are `INTEGER` 0/1 with a `CHECK` constraint.
- **Dates and times** are ISO-8601 text in UTC (`2024-12-01T14:30:00Z`).
- **Business ids** (`tfsa`, `d1`, `goal-1`) are unique only within a user, so most tables have a composite primary key starting with `user_id`.
- **Enumerations** (account type, transaction type and so on) are enforced with `CHECK` constraints that match the API's Zod enums.

## Changing the schema

Never edit a migration that has already been shared. Add a new one instead:

1. Create `migrations/002_<what_it_does>.sql`, using the next number.
2. If the new column needs demo values, update the seed files too.
3. Run `npm run db:migrate` (or `db:reset` to also re-seed) and check the result with `db:status` or DBeaver.
4. Commit the migration and seed changes together.
5. Update **electric-wealth-api**: its repository layer, its Zod schema, and its OpenAPI spec (`npm run gen:openapi`).

```sql
-- migrations/002_add_account_colour.sql
ALTER TABLE accounts ADD COLUMN colour TEXT;
```

SQLite's `ALTER TABLE` is limited. You can add a column, but renaming or dropping one with constraints usually means rebuilding the table (create new, copy, drop old, rename).

## Browsing the data in DBeaver

1. **Database → New Database Connection → SQLite**.
2. **Path:** browse to `electric-wealth-db/data/electric-wealth.db`.
3. The first time, DBeaver offers to download the SQLite driver. If your network blocks that, ask for the `sqlite-jdbc` jar and add it under **Driver Settings → Libraries**.
4. **Finish**, then expand **Tables**.

Close the connection (or disconnect) in DBeaver before running `npm run db:reset`.

Useful queries:

```sql
SELECT id, email, name FROM users;

SELECT a.display_name, a.type, a.balance / 100.0 AS balance_cad
FROM accounts a
WHERE a.user_id = 'sarah' AND a.hidden = 0
ORDER BY a.sort_order;

SELECT * FROM transactions WHERE user_id = 'sarah' AND account_id = 'tfsa' ORDER BY date DESC;
```

## Demo personas

Every persona's password is `Demo123!` and the MFA code is `123456`.

| Email | Persona |
|---|---|
| sarah.chen@example.com | Young professional saving for a first home |
| michael.thompson@example.com | Parent with two RESPs |
| linda.rodriguez@example.com | Pre-retiree (has one hidden account) |
| david.kim@example.com | Business owner with corporate investments |
| emma.wilson@example.com | New investor |
| robert.foster@example.com | Retired couple drawing RRIF income |

## Data model

```
users ─┬─ user_profiles (1:1)
       ├─ user_preferences (1:1)
       ├─ sessions
       ├─ accounts ─┬─ holdings
       │            ├─ transactions (posted + scheduled)
       │            ├─ account_performance (1:1)
       │            └─ performance_points (account + benchmark series)
       ├─ documents
       ├─ goals (show_on_dashboard flags the dashboard summary)
       ├─ portfolio_snapshots (1:1; day change, as-of)
       ├─ asset_allocations
       ├─ alerts
       └─ quick_links
```

The portfolio total on the dashboard is **not stored**. The API computes it as the sum of visible account balances.
