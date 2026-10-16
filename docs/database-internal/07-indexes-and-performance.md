---
slug: indexes-and-performance
title: "Indexes and Performance"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 7. Indexes and Performance

### 7.1 Indexing Strategy

**Philosophy (observed):** lean on the composite primary keys. Because nearly every per-user table's PK starts with `user_id`, the automatic PK index already serves `WHERE user_id = ? [AND id = ?]`. Explicit indexes are added only where a query sorts on a non-PK column or needs a secondary lookup.

**Index types used:**
- **B-tree** (SQLite's only index type), including the automatic `sqlite_autoindex_*` indexes for non-rowid PKs and UNIQUE columns (36).
- **Composite indexes** with a `DESC` column to match `ORDER BY … DESC`.
- **Partial unique index:** `ux_appointments_advisor_slot … WHERE status = 'scheduled'`.

### 7.2 Explicit Index Catalogue (7)

| Index | Table | Columns | Unique | Defined in | Serves |
|---|---|---|---|---|---|
| `ix_sessions_user` | `sessions` | `(user_id)` | no | `001:63` | FK cascade from `users`; per-user session lookups |
| `ix_transactions_account_date` | `transactions` | `(user_id, account_id, date DESC)` | no | `001:116` | `listPostedTransactions … ORDER BY date DESC, id` |
| `ix_notifications_user_created` | `notifications` | `(user_id, created_at DESC)` | no | `002:15` | Inbox `ORDER BY created_at DESC, id` |
| `ix_document_shares_document` | `document_shares` | `(user_id, document_id)` | no | `003:15` | FK cascade from `documents` |
| `ix_appointments_user` | `appointments` | `(user_id, date, time)` | no | `005:27` | `listAppointments … ORDER BY date, time`; FK cascade from `users` |
| `ux_appointments_advisor_slot` | `appointments` | `(advisor_id, date, time) WHERE status='scheduled'` | **yes, partial** | `005:30` | Double-booking guard; availability query `WHERE advisor_id=? AND status='scheduled' AND date BETWEEN ? AND ?` |
| `ix_advisor_messages_user` | `advisor_messages` | `(user_id, sent_at)` | no | `005:41` | Thread `ORDER BY sent_at, id`; FK cascade from `users` |

### 7.3 Index Maintenance

SQLite has no fragmentation-driven reindex schedule, and none is configured. The database is rebuilt from scratch with `npm run db:reset`, so indexes are always fresh. Useful commands if a long-lived copy ever exists:

```sql
ANALYZE;                 -- refresh sqlite_stat1 for the planner (never run by the scripts)
REINDEX;                 -- rebuild all indexes
VACUUM;                  -- reclaim free pages
PRAGMA integrity_check;  -- verify the B-trees
PRAGMA foreign_key_check;-- list FK violations (useful after a FK-off session)
```

### 7.4 Gaps and Observations

| Observation | Impact at current size | Impact if data grew |
|---|---|---|
| FK child columns **without** a leading index: `users.advisor_id`, `appointments.advisor_id` (covered only for `status='scheduled'` rows), `advisor_messages.advisor_id`, `offline_clients.advisor_id`, `offline_clients.enrolled_user_id`, `registrations.account_number`, `registrations.user_id`, `education_progress.content_id`, `watchlist.symbol`, `user_security_answers.question_id`, `registration_security_answers.question_id` | None (tables have ≤ 30 rows) | Deleting a parent (`users`, `advisors`, `securities`, `education_content`) does a full scan of each such child table to check or cascade. |
| `market_roundup_items.week_of` is unindexed; read with `MAX(week_of)` and then `WHERE week_of = ?` | None (3 rows) | Full scan per request |
| `documents` list sorts `year DESC, action_required DESC, id` with no matching index | None (~7 rows per user) | Temp B-tree sort per request |
| `sessions` is never purged | Grows by 1 row per sign-in or refresh | Unbounded growth; PK lookups stay O(log n) |
| `LIKE '%…%'` searches on `securities` and `glossary_terms` | None | Leading wildcard: full scan regardless of indexes |

### 7.5 Query Performance Guidelines

1. **Always filter on `user_id` first.** It is the leading PK column of every tenant table, so the PK index is used.
2. **Match the explicit index order** when sorting: transactions by `date DESC`, notifications by `created_at DESC`, appointments by `date, time`, messages by `sent_at`.
3. **Avoid `SELECT *` in new code.** The current repositories use it widely, which is acceptable for these narrow tables.
4. **Page with `LIMIT ? OFFSET ?`** as `AccountRepository`/`GoalRepository`/`DocumentRepository` do. OFFSET is linear, but per-user row counts are tiny.
5. **Keep write transactions short.** The rollback journal (`journal_mode=delete`) locks the whole file during a write.

**EXPLAIN example (SQLite):**

```sql
EXPLAIN QUERY PLAN
SELECT * FROM transactions
WHERE user_id = 'sarah' AND account_id = 'tfsa' AND status = 'posted'
ORDER BY date DESC, id LIMIT 20 OFFSET 0;
-- Actual (sqlite3 3.51.0, 2026-10-15):
--   SEARCH transactions USING INDEX ix_transactions_account_date (user_id=? AND account_id=?)
--   USE TEMP B-TREE FOR LAST TERM OF ORDER BY   (because of the trailing ", id" tie-breaker)
```

---

# Part 3 — Views and Derived Data

This database has **no views, materialized views, stored procedures, functions or triggers**. Sections 8–11 (views, materialization and refresh strategy, stored procedures and functions, triggers) are omitted by the composition's decision gates. Derived values are either stored denormalised (`goals.progress_pct`, `holdings.name`, `documents.account_label`) or computed in the API (portfolio total = `SUM(balance)` of visible accounts).
