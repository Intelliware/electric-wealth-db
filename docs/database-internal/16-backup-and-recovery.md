---
slug: backup-and-recovery
title: "Backup and Recovery"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 16. Backup and Recovery

### 16.1 Backup Strategy

| Environment | Frequency | Type | Retention | RTO | RPO |
|-------------|-----------|------|-----------|-----|-----|
| **Development (local)** | None | **Rebuild from source** (`npm run db:reset`) | n/a | Seconds (one reset) | All runtime writes since the last reset (sessions, registrations, new accounts and goals, bookings, messages, watchlist and progress changes) |
| **Staging / Production** | Not defined | — | — | — | — |

The database is a **disposable build artifact**. The source of truth is `migrations/` + `seed/` in git, and the `.db` file is git-ignored. Anything the API writes at runtime is lost on reset by design.

### 16.2 Backup Tools and Procedures

If you need to keep a runtime state (for example, to reproduce a bug):

```bash
# Online-safe copy (uses SQLite's backup API; consistent even if the API is connected)
sqlite3 data/electric-wealth.db ".backup data/electric-wealth.backup.db"

# Plain-SQL dump (portable, diffable)
sqlite3 data/electric-wealth.db .dump > electric-wealth.sql

# Restore: stop the API first, then
cp data/electric-wealth.backup.db data/electric-wealth.db
# or
rm data/electric-wealth.db && sqlite3 data/electric-wealth.db < electric-wealth.sql
```

Do **not** copy the `.db` file with `cp` while the API is writing. With `journal_mode=delete`, a copy taken mid-transaction can be inconsistent; use `.backup` instead.

### 16.3 Point-In-Time Recovery (PITR)

Not available. SQLite in rollback-journal mode keeps no transaction log history. The only recovery points are explicit `.backup`/`.dump` copies, or a rebuild from migrations + seed.
