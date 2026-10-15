# electric-wealth-db

The database for Electric Wealth. Uses **SQLite** through Node's built-in `node:sqlite` module, so you don't need Docker, a database server, admin rights, or even `npm install`.

## Getting started (Windows, macOS, Linux)

Prerequisite: **Node.js 24** (`node --version`). The workshop standard is 24.19.0, as pinned in `.nvmrc`.

Clone `electric-wealth-db`, `electric-wealth-api-spring` and `electric-wealth-web` side by side, then:

```bash
npm run db:reset     # build data/electric-wealth.db
npm run db:status    # check it worked
```

The Spring API expects the database at `../electric-wealth-db/data/electric-wealth.db`, which is the default location.

| Script | What it does |
|---|---|
| `npm run db:reset` | Deletes the database file and rebuilds it from scratch |
| `npm run db:migrate` | Applies pending migrations |
| `npm run db:seed` | Loads seed data into an empty database (`-- --force` to override) |
| `npm run db:status` | Shows migration status and row counts |

To use a different file, pass `--db <path>` or set `DB_PATH`:

```bash
npm run db:reset -- --db C:\temp\ew-test.db
```

> **Stop the Spring API before running `db:reset`.** On Windows, an open connection locks the file.

## Opening the database in DBeaver

1. **Database → New Database Connection → SQLite**.
2. **Path:** browse to `electric-wealth-db/data/electric-wealth.db`.
3. The first time, DBeaver offers to download the SQLite driver. If your network blocks that, ask for the `sqlite-jdbc` jar and add it under **Driver Settings → Libraries**.
4. **Finish**, then expand **Tables**.

Close the connection (or disconnect) in DBeaver before running `npm run db:reset`.
