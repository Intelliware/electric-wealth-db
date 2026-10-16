---
slug: environment-and-configuration
title: "Environment and Configuration"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 2. Environment and Configuration

### 2.1 Prerequisites and Versions

| Dependency | Required Version | Notes |
|------------|------------------|-------|
| Node.js | `>=24` (`package.json` `engines`); workshop standard **24.19.0** (`.nvmrc`) | Provides the built-in `node:sqlite` module (`DatabaseSync`). No `npm install` is needed: the repo has no dependencies. |
| SQLite engine | Whatever Node 24 bundles (scripts); `sqlite-jdbc` **3.53.4.0** (Spring API, `pom.xml`) | Two different SQLite builds open the same file. All DDL in use is basic SQLite 3 and works on both. |
| Disk | < 1 MB | The seeded file is ~440 KB. |
| OS | Windows, macOS, Linux | README: "Getting started (Windows, macOS, Linux)". |
| GUI client (optional) | DBeaver with the SQLite driver | README § "Opening the database in DBeaver". |
| Authentication | None | SQLite has no users or roles; file-system access is the only control. |

### 2.2 Connection Information

#### Development (the only environment)

```
Engine:      SQLite 3 (file)
File:        <electric-wealth-db>/data/electric-wealth.db   (default)
Override:    --db <path>  or  DB_PATH=<path>                 (scripts/lib.js resolveDbPath)
Credentials: none
Node URL:    new DatabaseSync('<file>') + PRAGMA foreign_keys = ON
JDBC URL:    jdbc:sqlite:<absolute file>?foreign_keys=true&busy_timeout=3000   (API DatabaseConfig.java)
Tools:       sqlite3 CLI, DBeaver (SQLite driver / sqlite-jdbc jar)
```

How the path is resolved:

| Consumer | Precedence |
|---|---|
| DB scripts (`scripts/lib.js` `resolveDbPath`) | 1. `--db <path>` argument → 2. `DB_PATH` env var → 3. `data/electric-wealth.db` inside the repo |
| Spring API (`application.yml` `ew.db-path`) | `${DB_PATH:../electric-wealth-db/data/electric-wealth.db}`, resolved against the API's working directory. Can also come from an optional `.env` file. |

#### Staging / Production

Not defined. No staging or production connection exists anywhere in the source.

### 2.3 Configuration and Parameters

SQLite has no server configuration. These per-connection settings are applied by the code:

```sql
-- Node scripts (scripts/lib.js openDatabase)
PRAGMA foreign_keys = ON;        -- FK enforcement is OFF by default in SQLite; must be set on every connection

-- Spring API (DatabaseConfig.java JDBC URL parameters)
foreign_keys=true                -- same as above, applied by sqlite-jdbc on every pooled connection
busy_timeout=3000                -- wait up to 3 s for a lock before failing with SQLITE_BUSY
```

Defaults observed on the built file (no PRAGMA changes them):

| Setting | Value | Implication |
|---|---|---|
| `journal_mode` | `delete` (rollback journal, not WAL) | Writers block readers for the length of a write transaction. `reset()` also cleans up any leftover `-wal`/`-shm`/`-journal` files. |
| Connection pool (API) | HikariCP `maximum-pool-size: 4` | Caps concurrent connections to the file. |

### 2.4 Environment-Specific Behaviors

| Behavior | Development (local) | Staging | Production |
|----------|-------------|---------|-----------|
| **Build / refresh** | `npm run db:reset` deletes and rebuilds the file from migrations + seed | n/a | n/a |
| **Slow-query log** | None | n/a | n/a |
| **Backups** | None; the file is git-ignored (`.gitignore`: `data/`, `*.db`) | n/a | n/a |
| **Read replica** | No | n/a | n/a |
| **Row-level security** | Not supported by SQLite; tenancy is enforced in API queries (`WHERE user_id = ?`) | n/a | n/a |
| **File locking** | On Windows an open connection locks the file. Stop the API and close DBeaver before `db:reset` (README) | n/a | n/a |
