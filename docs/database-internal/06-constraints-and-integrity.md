---
slug: constraints-and-integrity
title: "Constraints and Integrity"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 6. Constraints and Integrity

### 6.1 Constraint Strategy

Integrity is enforced **in the database** for structure (PK, FK, CHECK, UNIQUE) and **in the API** for business rules, such as slot availability, identity matching, registration expiry and session expiry.

**Critical precondition:** SQLite only enforces foreign keys when `PRAGMA foreign_keys = ON` is set **on the connection**. It is not stored in the file. Both owners set it:
- Node scripts: `db.exec('PRAGMA foreign_keys = ON;')` in `scripts/lib.js openDatabase`.
- Spring API: `?foreign_keys=true` on the JDBC URL (`DatabaseConfig.java`).
- **Any other client (sqlite3 CLI, DBeaver, ad-hoc scripts) has FKs OFF unless it sets the pragma itself.** On such a connection deletes do not cascade and orphans can be inserted.

### 6.2 Primary Key Strategy

**Strategy:** natural or application-generated **TEXT** keys. Tenant-owned tables use a **composite PK whose first column is `user_id`**.

| Pattern | Tables | Generation |
|---|---|---|
| `(user_id, id)` composite | `accounts`, `documents`, `goals`, `alerts`, `notifications` | Seeds: short slugs (`tfsa`, `d1`, `no1`). API: `acct-<8 hex>`, goal ids, `welcome`. |
| `(user_id, account_id, …)` composite | `holdings` (+`symbol`), `transactions` (+`id`), `account_performance`, `performance_points` (+`series`,`period`) | |
| `user_id` alone (1:1) | `user_profiles`, `user_preferences`, `portfolio_snapshots` | |
| `(user_id, <natural>)` | `asset_allocations` (+`asset_class`), `quick_links` (+`sort_order`), `watchlist` (+`symbol`), `education_progress` (+`content_id`), `user_security_answers` (+`question_id`) | |
| Global TEXT id | `users` (`sarah` / `u-<8 hex>`), `appointments` (`appt-<8 hex>`), `advisor_messages` (`msg-<8 hex>`), `registrations` (`reg-<8 hex>`), `advisors`, `education_content`, `glossary_terms`, `security_questions`, `market_news`, `market_roundup_items`, `baskets` | `UUID.randomUUID().toString().substring(0, 8)` in Java: 32 bits of randomness, no collision retry |
| Natural key | `securities.symbol`, `offline_clients.account_number`, `sessions.access_token`, `schema_migrations.version` | |
| INTEGER AUTOINCREMENT | `document_shares.id` | SQLite rowid; uses `sqlite_sequence` |

**Rationale (from source):** "Business ids … are only unique per user, so most tables use a composite primary key that starts with user_id." A side effect is that every per-user query is an index range scan on the PK.

**Caveat:** the 8-hex-character ids carry only 32 bits of randomness. For a global PK such as `users.id` or `appointments.id`, a collision surfaces as a `UNIQUE constraint failed` error, not silent corruption.

### 6.3 Foreign Key Constraints

34 FKs: **25 `ON DELETE CASCADE`**, **9 `NO ACTION`** (SQLite's default, which behaves like RESTRICT at statement end). **No FK declares `ON UPDATE`**, so all are NO ACTION. All values below were verified with `pragma_foreign_key_list`.

| Rule | Used for | Implication |
|------|-----------|-------------|
| **CASCADE** | Every user-owned table → `users`; account children → `accounts` (composite); `document_shares` → `documents` (composite); `education_progress.content_id`; `price_history`/`watchlist` → `securities`; `registration_security_answers` → `registrations` | Deleting the parent removes the children. Deleting a `users` row wipes that client's data across 16 tables, plus the grandchildren under `accounts` and `documents`. |
| **NO ACTION** | `users.advisor_id`, `appointments.advisor_id`, `advisor_messages.advisor_id`, `offline_clients.advisor_id`, `offline_clients.enrolled_user_id`, `registrations.account_number`, `registrations.user_id`, `registration_security_answers.question_id`, `user_security_answers.question_id` | The parent cannot be deleted while referenced. Reference data (advisors, security questions, branch clients) is protected. **`users` deletion is also blocked** by `offline_clients.enrolled_user_id` and `registrations.user_id`. |
| SET NULL / SET DEFAULT | Not used | — |

**Complete FK list:**

| Child (FK columns) | Parent | ON DELETE |
|---|---|---|
| `user_profiles(user_id)` | `users(id)` | CASCADE |
| `user_preferences(user_id)` | `users(id)` | CASCADE |
| `sessions(user_id)` | `users(id)` | CASCADE |
| `accounts(user_id)` | `users(id)` | CASCADE |
| `holdings(user_id, account_id)` | `accounts(user_id, id)` | CASCADE |
| `transactions(user_id, account_id)` | `accounts(user_id, id)` | CASCADE |
| `account_performance(user_id, account_id)` | `accounts(user_id, id)` | CASCADE |
| `performance_points(user_id, account_id)` | `accounts(user_id, id)` | CASCADE |
| `documents(user_id)` | `users(id)` | CASCADE |
| `document_shares(user_id, document_id)` | `documents(user_id, id)` | CASCADE |
| `goals(user_id)` | `users(id)` | CASCADE |
| `portfolio_snapshots(user_id)` | `users(id)` | CASCADE |
| `asset_allocations(user_id)` | `users(id)` | CASCADE |
| `alerts(user_id)` | `users(id)` | CASCADE |
| `quick_links(user_id)` | `users(id)` | CASCADE |
| `notifications(user_id)` | `users(id)` | CASCADE |
| `education_progress(user_id)` | `users(id)` | CASCADE |
| `education_progress(content_id)` | `education_content(id)` | CASCADE |
| `users(advisor_id)` | `advisors(id)` | NO ACTION |
| `appointments(user_id)` | `users(id)` | CASCADE |
| `appointments(advisor_id)` | `advisors(id)` | NO ACTION |
| `advisor_messages(user_id)` | `users(id)` | CASCADE |
| `advisor_messages(advisor_id)` | `advisors(id)` | NO ACTION |
| `price_history(symbol)` | `securities(symbol)` | CASCADE |
| `watchlist(user_id)` | `users(id)` | CASCADE |
| `watchlist(symbol)` | `securities(symbol)` | CASCADE |
| `offline_clients(advisor_id)` | `advisors(id)` | NO ACTION |
| `offline_clients(enrolled_user_id)` | `users(id)` | NO ACTION |
| `registrations(account_number)` | `offline_clients(account_number)` | NO ACTION |
| `registrations(user_id)` | `users(id)` | NO ACTION |
| `registration_security_answers(registration_id)` | `registrations(id)` | CASCADE |
| `registration_security_answers(question_id)` | `security_questions(id)` | NO ACTION |
| `user_security_answers(user_id)` | `users(id)` | CASCADE |
| `user_security_answers(question_id)` | `security_questions(id)` | NO ACTION |

**Logical relationships NOT enforced by an FK:**

| Column | Points at | Why it matters |
|---|---|---|
| `holdings.symbol` | `securities.symbol` | A holding can reference an unknown ticker. All seeded symbols resolve. |
| `documents.account_id` | `accounts(user_id, id)` | Nullable by design (NULL = all accounts). Deleting an account leaves the document's `account_id` dangling. |
| `users.account_number` | `offline_clients.account_number` | Linked only by value. The enrolment back-link is `offline_clients.enrolled_user_id`. |

### 6.4 Unique Constraints

| Table | Constraint | Rationale | Enforcement |
|-------|-----------|-----------|-------------|
| `users` | `email` UNIQUE, `COLLATE NOCASE` | One login per email address | Case-insensitive at the database level (`sqlite_autoindex_users_2`) |
| `sessions` | `refresh_token` UNIQUE | Refresh tokens identify exactly one session | `sqlite_autoindex_sessions_2` |
| `appointments` | `ux_appointments_advisor_slot (advisor_id, date, time) WHERE status = 'scheduled'` | An advisor can have only one scheduled meeting per slot | **Partial** unique index; cancelled and completed rows do not count |
| `registrations` | *(none on `email`)* | Several in-progress registrations may share an email | The API checks `users.email` (`emailInUse`) instead |
| All tables | Composite PKs (§ 6.2) | Per-user business-id uniqueness | `sqlite_autoindex_*` |

### 6.5 Check Constraints

34 inline CHECKs, all unnamed. On violation SQLite reports the expression, e.g. `CHECK constraint failed: type IN ('TFSA', 'RRSP', 'RESP', 'RDSP', 'FHSA', 'NON_REGISTERED', 'LIRA', 'RRIF')` (verified).

| Kind | Columns |
|---|---|
| **Boolean 0/1** (11) | `user_preferences.notify_email`/`notify_sms`/`notify_push`, `sessions.mfa_verified`/`revoked`, `accounts.hidden`, `documents.action_required`, `goals.show_on_dashboard`, `notifications.read`, `advisors.available`, `registrations.security_answers_saved` |
| **Enumerations** (21) | `accounts.type` (8 values), `transactions.type` (8), `transactions.status` (`posted`,`scheduled`), `performance_points.series` (`account`,`benchmark`), `goals.category` (5), `alerts.type` / `notifications.type` (`ACTION_REQUIRED`,`INFO`,`SUCCESS`,`WARNING`), `user_preferences.document_delivery`/`language`/`theme`/`default_meeting_type`, `education_content.level`/`type`, `appointments.meeting_type`/`status`, `advisor_messages.sender`, `price_history.range`, `baskets.risk`, `offline_clients.language`, `registrations.mfa_method`, `users.mfa_method` |
| **Ranges** (2) | `education_content.duration_min > 0`; `education_progress.progress_pct BETWEEN 0 AND 100` |

**Not CHECKed (free text, values observed in seed):** `accounts.tax_status`, `documents.category`, `asset_allocations.asset_class`, every `currency` column, `user_profiles.province`/`country`, and the formats of all date/time TEXT columns. Monetary amounts have no sign or range checks.

### 6.6 Handling Constraint Violations

SQLite returns result code **19 (`SQLITE_CONSTRAINT`)** with a message. sqlite-jdbc surfaces it as `SQLiteException` wrapped by Spring in a `DataAccessException` subclass (typically `DataIntegrityViolationException`).

```sql
-- Duplicate scheduled slot (verified on a copy of the seeded DB)
INSERT INTO appointments VALUES ('x2','david','adv-1','video','2030-01-02','09:00','scheduled',NULL,'now');
-- Error: UNIQUE constraint failed: appointments.advisor_id, appointments.date, appointments.time (19)

-- Deleting an enrolled user (verified)
DELETE FROM users WHERE id = 'emma';
-- Error: FOREIGN KEY constraint failed (19)
```

The only place the API inspects a constraint error is advisor booking (`AdvisorController.bookingSlot`):

```java
} catch (DataAccessException e) {
    if (String.valueOf(e.getMostSpecificCause().getMessage()).contains("UNIQUE constraint failed")) {
        throw slotTaken();   // HTTP 409 SLOT_UNAVAILABLE
    }
    throw e;
}
```

Every other path validates before writing, or uses `ON CONFLICT` (watchlist, education progress), so constraint errors are not expected in normal operation.
