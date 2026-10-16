---
slug: code-examples
title: "Code Examples"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 28. Code Examples

### Java / Spring (`JdbcClient`), as used by `electric-wealth-api-spring`

```java
@Repository
public class AccountRepository {
    private final JdbcClient jdbc;

    public AccountRepository(JdbcClient jdbc) { this.jdbc = jdbc; }

    /** Paged, tenant-scoped read. Matches AccountRepository.listVisible. */
    public PageResult<AccountSummary> listVisible(String userId, int page, int pageSize) {
        long total = jdbc.sql("SELECT COUNT(*) FROM accounts WHERE user_id = ? AND hidden = 0")
                .param(userId).query(Long.class).single();
        List<AccountSummary> items = jdbc.sql("""
                SELECT * FROM accounts WHERE user_id = ? AND hidden = 0 ORDER BY sort_order LIMIT ? OFFSET ?""")
                .params(userId, pageSize, (page - 1) * pageSize)
                .query(Rows.of(AccountSummary.class)).list();
        return new PageResult<>(items, total);
    }

    /** Multi-statement write in one transaction. Matches AccountRepository.open. */
    @Transactional
    public String open(String userId, AccountOpenRequest input) {
        String id = "acct-" + UUID.randomUUID().toString().substring(0, 8);
        int next = jdbc.sql("SELECT COALESCE(MAX(sort_order), 0) + 1 FROM accounts WHERE user_id = ?")
                .param(userId).query(Integer.class).single();
        jdbc.sql("""
                INSERT INTO accounts (user_id, id, type, display_name, nickname, balance, currency, hidden, day_change,
                                      day_change_pct, contribution_room, tax_status, rate_of_return, sort_order)
                VALUES (?, ?, ?, ?, ?, 0, 'CAD', 0, 0, 0, ?, ?, 0, ?)""")
                .params(userId, id, "TFSA", input.displayName(), null, 700_000L, "Tax-free", next).update();
        jdbc.sql("""
                INSERT INTO account_performance (user_id, account_id, time_weighted_return_pct, currency, benchmark_name)
                VALUES (?, ?, 0, 'CAD', 'S&P/TSX Composite')""").params(userId, id).update();
        return id;
    }
}
```

**Upsert (idempotent write).** Matches `EducationRepository.saveProgress`:
```java
jdbc.sql("""
        INSERT INTO education_progress (user_id, content_id, progress_pct, updated_at)
        VALUES (?, ?, ?, strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
        ON CONFLICT (user_id, content_id)
        DO UPDATE SET progress_pct = excluded.progress_pct, updated_at = excluded.updated_at""")
    .params(userId, contentId, progressPct).update();
```

**Using a constraint as a concurrency guard.** Matches `AdvisorController.bookingSlot`:
```java
try {
    advisors.createAppointment(userId, advisorId, input);
} catch (DataAccessException e) {
    if (String.valueOf(e.getMostSpecificCause().getMessage()).contains("UNIQUE constraint failed")) {
        throw new ApiException(HttpStatus.CONFLICT, "SLOT_UNAVAILABLE", "That time is no longer available.");
    }
    throw e;
}
```

### Node.js (`node:sqlite`), as used by `scripts/lib.js`

```js
import { DatabaseSync } from 'node:sqlite';

const db = new DatabaseSync('data/electric-wealth.db');
db.exec('PRAGMA foreign_keys = ON;');                 // required on every connection

const rows = db.prepare(
  'SELECT id, display_name, balance, currency FROM accounts WHERE user_id = ? AND hidden = 0 ORDER BY sort_order'
).all('sarah');

db.exec('BEGIN;');
try {
  db.prepare("UPDATE notifications SET read = 1 WHERE user_id = ? AND read = 0").run('sarah');
  db.exec('COMMIT;');
} catch (err) {
  db.exec('ROLLBACK;');
  throw err;
} finally {
  db.close();
}
```

### sqlite3 CLI (inspection)

```bash
sqlite3 -readonly data/electric-wealth.db -cmd "PRAGMA foreign_keys=ON;" -header -column \
  "SELECT a.display_name, printf('%.2f', a.balance/100.0) AS balance, a.currency
   FROM accounts a WHERE a.user_id = 'sarah' AND a.hidden = 0 ORDER BY a.sort_order;"
```
