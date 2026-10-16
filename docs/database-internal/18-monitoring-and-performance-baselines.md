---
slug: monitoring-and-performance-baselines
title: "Monitoring and Performance Baselines"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 18. Monitoring and Performance Baselines

### 18.1 Key Performance Indicators (KPIs)

No database monitoring, metrics export or alerting exists in source. The only built-in observability is `npm run db:status` (applied migrations + row counts) and the API's request log (`ew.log-requests: true`). The baselines below were **measured once** (2026-10-15) on the freshly seeded file and are reference points, not SLOs.

| Metric | Baseline (seeded) | Alert threshold | How to check |
|--------|----------|-----------------|---------|
| File size | 450,560 bytes | Not defined | `ls -l data/electric-wealth.db` or `PRAGMA page_count; PRAGMA page_size;` |
| Applied migrations | 7 of 7 | Any `PENDING` | `npm run db:status` |
| `sessions` rows | 0 after seed | Not defined (unbounded growth, § 17) | `SELECT COUNT(*) FROM sessions;` |
| `registrations` rows | 0 after seed | Not defined | `SELECT COUNT(*) FROM registrations;` |
| Lock waits | n/a | API errors containing `SQLITE_BUSY` / "database is locked" after the 3 s `busy_timeout` | API logs |
| Integrity | `ok` expected | Anything other than `ok` | `PRAGMA integrity_check;` |
| FK consistency | 0 rows expected | Any row | `PRAGMA foreign_key_check;` |

### 18.2 Monitoring Queries

**Migration and row-count status (built-in):**
```bash
npm run db:status
# Database: …/data/electric-wealth.db
# Migrations:
#   applied  001_initial_schema.sql  (2026-…)
#   …
# Row counts:
#   account_performance    27
#   …
```

**Health checks (sqlite3):**
```sql
PRAGMA integrity_check;          -- 'ok'
PRAGMA foreign_key_check;        -- no rows = no orphans (important after any FK-off session)
SELECT version, applied_at FROM schema_migrations ORDER BY version;
```

**Query plan inspection (no pg_stat_statements equivalent):**
```sql
EXPLAIN QUERY PLAN SELECT * FROM notifications WHERE user_id = 'sarah' ORDER BY created_at DESC, id;
-- SEARCH notifications USING INDEX ix_notifications_user_created (user_id=?)
-- USE TEMP B-TREE FOR LAST TERM OF ORDER BY
```

**Session table growth:**
```sql
SELECT COUNT(*) AS total,
       SUM(revoked) AS revoked,
       SUM(expires_at < strftime('%Y-%m-%dT%H:%M:%fZ','now')) AS expired
FROM sessions;
```

---

# Part 8 — Consumer Guide

The consumer guide (sections 19–24) is published in the knowledge base at `electric-wealth-knowledge-base/source-docs/electric-wealth-db/database-consumer/`.
