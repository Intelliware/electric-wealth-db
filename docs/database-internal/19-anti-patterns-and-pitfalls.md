---
slug: anti-patterns-and-pitfalls
title: "Anti-Patterns and Pitfalls"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 25. Anti-Patterns and Pitfalls

### 25.1 Pitfall: Connecting Without `foreign_keys` ON

**Problem:**
```bash
sqlite3 data/electric-wealth.db "DELETE FROM accounts WHERE user_id='sarah' AND id='tfsa';"
# FKs are OFF by default in the sqlite3 CLI and in DBeaver.
# The account is deleted, but its holdings/transactions/performance rows remain as orphans.
```

**Solution:**
```bash
sqlite3 data/electric-wealth.db -cmd "PRAGMA foreign_keys=ON;" "DELETE FROM accounts WHERE …;"
# Afterwards, check: PRAGMA foreign_key_check;   (should return no rows)
```

### 25.2 Pitfall: Querying a Tenant Table Without `user_id`

**Problem:**
```sql
SELECT * FROM accounts WHERE id = 'tfsa';    -- returns one TFSA per persona, not "the" TFSA
```

**Solution:**
```sql
SELECT * FROM accounts WHERE user_id = ? AND id = 'tfsa';
```
Business ids (`tfsa`, `d1`, `goal-1`, `no1`) are unique **per user only**.

### 25.3 Pitfall: Treating Money as Dollars or REAL

**Problem:**
```sql
SELECT SUM(balance) FROM accounts WHERE user_id = 'sarah';   -- 6025000, which is cents, not dollars
UPDATE accounts SET balance = 32410.00 WHERE …;               -- stores REAL dollars into a cents column
```

**Solution:** keep INTEGER minor units end-to-end and format at the edge (`balance / 100.0` only for display). Never mix currencies in a `SUM`; the schema allows `CAD` and `USD` rows.

### 25.4 Pitfall: Inconsistent Timestamp Precision

Two formats coexist: second precision (`2024-12-01T13:30:00Z`, used by seeds, `strftime` defaults and most API writes) and millisecond precision (`…15:23:19.707Z`, used by `sessions`). Lexical comparison across the two is off by up to one second (`'Z'` sorts after `'.'`). Do not mix precisions within one column. Use `SqlValues.isoSeconds` for new columns unless sub-second ordering matters.

### 25.5 Pitfall: Assuming `appointments.date/time` Are UTC

They are **Toronto local time** (`005_advisor.sql` comment; `AdvisorRepository.TIME_ZONE = America/Toronto`). Every other timestamp is UTC.

### 25.6 Anti-Pattern: Plain-Text Secrets

`users.password`, `registrations.password`, security answers and `users.mfa_code` are plain text. This is acceptable **only** because this is demo data. Do not copy the pattern into new tables.

### 25.7 Pitfall: Editing an Applied Migration

The runner records only file names (no checksums). Editing `00N_*.sql` after it has been applied does nothing to existing databases. Add a new migration, or `npm run db:reset` locally.

### 25.8 Pitfall: `SELECT MAX(sort_order) + 1` Outside a Transaction

`AccountRepository.open` and `GoalRepository.create` compute the next `sort_order` and INSERT inside `@Transactional`. Copy that pattern. Without a transaction, two concurrent creates can get the same `sort_order`. That is harmless here (not unique) but produces an unstable order.

### 25.9 Pitfall: Running `db:reset` With Open Connections

On Windows the API or DBeaver holds a lock and the delete fails. On macOS/Linux the delete *succeeds*, and the running API keeps writing to the unlinked old inode until restarted. Stop the API and close DBeaver first.
