---
slug: authentication-and-connection
title: "Authentication and Connection"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 13. Authentication and Connection

### 13.1 Connection Strings

#### Development (only environment)

```
Type:        SQLite 3 (file)
File:        ../electric-wealth-db/data/electric-wealth.db   (relative to the API repo root)
Database:    main
Username:    n/a (SQLite has no authentication)
Password:    n/a
Pooling:     HikariCP, maximum-pool-size 4 (Spring API)

Spring API JDBC URL (built in DatabaseConfig.java):
jdbc:sqlite:/abs/path/electric-wealth.db?foreign_keys=true&busy_timeout=3000

Node (scripts/lib.js):
new DatabaseSync('/abs/path/electric-wealth.db'); db.exec('PRAGMA foreign_keys = ON;');

sqlite3 CLI (read-only inspection, FKs on):
sqlite3 -readonly data/electric-wealth.db -cmd "PRAGMA foreign_keys=ON;"
```

#### Staging / Production

Not defined in source.

### 13.2 Credential Management

There are no database credentials to manage. Configuration is limited to **where the file lives**:

| Setting | Where | Default |
|---|---|---|
| `DB_PATH` env var | DB scripts and Spring API | Scripts: `data/electric-wealth.db`; API: `../electric-wealth-db/data/electric-wealth.db` |
| `--db <path>` flag | DB scripts only | — |
| `.env` file | Spring API (`spring.config.import: optional:file:.env[.properties]`); git-ignored in both repos | — |

**Startup check:** the API refuses to start if the file is missing. It fails with `Database not found at <path>. Build it first: cd ../electric-wealth-db && npm run db:reset` (`DatabaseConfig.java`).

**Never:**
- Commit `data/*.db` or `.env` (both are git-ignored).
- Point `DB_PATH` at a shared network drive. SQLite file locking over network file systems is unreliable.
- Run `npm run db:reset` while the API or DBeaver has the file open. On Windows the open handle locks the file (README).

**Development setup:**
```bash
cd electric-wealth-db
npm run db:reset            # build data/electric-wealth.db
npm run db:status           # verify migrations + row counts
# optional: use another file
DB_PATH=/tmp/ew-test.db npm run db:reset
```

---

# Part 6 — Data Management
