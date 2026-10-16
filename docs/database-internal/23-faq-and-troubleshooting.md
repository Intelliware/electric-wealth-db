---
slug: faq-and-troubleshooting
title: "FAQ and Troubleshooting"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 29. FAQ and Troubleshooting

### Q: The API won't start: "Database not found at …"

**A:** The file hasn't been built, or `DB_PATH` points elsewhere. Run `cd ../electric-wealth-db && npm run db:reset`, or set `DB_PATH` in the API's `.env`.

### Q: `npm run db:reset` fails with EBUSY / "resource busy or locked" (Windows)

**A:** The Spring API or DBeaver still has the file open. Stop the API and disconnect DBeaver, then retry (README).

### Q: The API returns errors mentioning "database is locked" / `SQLITE_BUSY`

**A:** Another connection held a write lock for longer than `busy_timeout=3000` ms. Typical causes are a long-running write in DBeaver with auto-commit off, or a `db:migrate`/`db:seed` running against the live file. Commit or close the other session.

### Q: Why is my query slow?

**A:** At seed size (≤ 408 rows per table) nothing should be slow. If something is, run `EXPLAIN QUERY PLAN …` and check that the query filters on `user_id` (the leading PK column). See § 7.4 for unindexed FK columns.

### Q: Can I delete a user?

**A:** Not directly. `DELETE FROM users WHERE id = ?` fails with `FOREIGN KEY constraint failed`, because `offline_clients.enrolled_user_id` (and possibly `registrations.user_id`) reference the user with NO ACTION. First clear those references (set them to NULL), then delete. Everything else cascades. Or simply `npm run db:reset`.

### Q: I deleted rows in DBeaver and now the app shows odd data

**A:** DBeaver connections have FKs **off** by default, so the cascades did not run. Check with `PRAGMA foreign_key_check;` and fix, or `npm run db:reset`.

### Q: How do I handle NULL values?

**A:** Use `IS NULL` / `IS NOT NULL`. Meaningful NULLs in this schema:
- `documents.account_id IS NULL` means the document applies to all accounts.
- `users.advisor_id IS NULL` means no advisor is assigned.
- `registrations.user_id IS NULL` means the registration is not completed.
- `offline_clients.enrolled_user_id IS NULL` means the client has not enrolled online.
- No `education_progress` row means 0% (use `LEFT JOIN … COALESCE(p.progress_pct, 0)`).
- `accounts.contribution_room IS NULL` means not applicable or unknown.

### Q: What isolation level should I use?

**A:** SQLite transactions are always **serializable**: there is a single writer and readers see a consistent snapshot. Wrap multi-statement writes in one transaction (`@Transactional` in Spring, `BEGIN … COMMIT` in Node). For read-then-write sequences that must not interleave, `BEGIN IMMEDIATE` takes the write lock up front.

### Q: I changed a migration and nothing happened

**A:** Applied migrations are tracked by file name only. Run `npm run db:reset`, or add a new migration (§ 15).

### Q: `npm run db:seed` says "Database already has N user(s); skipping seed"

**A:** That is intended. Use `npm run db:reset` for a clean reseed. `-- --force` will hit duplicate-key errors on a populated DB.

### Q: Where do the Spring API and the database disagree?

**A:** They are designed to match. The API mirrors CHECK enumerations as Java enums, writes timestamps in the same ISO format as the Node API (`SqlValues`), and never runs DDL. If you add a CHECK value in a migration, update `ApiEnums` too.
