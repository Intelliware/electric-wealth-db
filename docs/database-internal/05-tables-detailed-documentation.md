---
slug: tables-detailed-documentation
title: "Tables — Detailed Documentation"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 5. Tables — Detailed Documentation

**Source of truth:** the DDL in `migrations/001`–`007`. Row counts were measured on 2026-10-15 against a freshly seeded database. One `sessions` row came from a sign-in after the seed ran.

**Conventions that apply to every table below.** They are stated once here and not repeated per column.
- **Money columns** (INTEGER) hold minor units (cents) of the row's `currency`. `3241000` with `CAD` means $32,410.00.
- **Boolean columns** (INTEGER) are `CHECK (col IN (0, 1))`.
- **Timestamps** are ISO-8601 TEXT in UTC. Seeds and most API writes use second precision (`2024-12-01T13:30:00Z`). `sessions` uses millisecond precision (`…T15:23:19.707Z`).
- **ON UPDATE** is `NO ACTION` for every FK. Primary keys are treated as immutable.
- There are **no triggers** and **no soft-delete columns** on any table.
- **Growth/volatility** describe the demo workload; there is no production telemetry.

---

## 5.A Identity and Auth

### `users` — `001_initial_schema.sql:15`, altered by `005:12` and `007:65–66`

#### 5.1.1 Entity Overview
- **Description:** An online-banking login for a client. The central hub table; 18 tables reference it.
- **Row count:** 6 (personas). **Growth:** +1 per completed online registration (`RegistrationRepository.complete`).
- **Volatility:** Low. Only `advisor_id` is set by the seed and `terms_accepted_at` by registration; the API has no profile edit for these columns.

#### 5.1.2 Column Definitions

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | User id. Seeded personas use a short name; registrations generate `u-<8 hex>`. | `sarah`, `u-1a2b3c4d` |
| `email` | TEXT | NO | UNIQUE, `COLLATE NOCASE` | — | Login email. Uniqueness and equality are case-insensitive. | `sarah.chen@example.com` |
| `password` | TEXT | NO | — | — | **Demo only: plain text.** | `Demo123!` |
| `mfa_code` | TEXT | NO | — | — | **Demo only:** fixed one-time code. | `123456` |
| `name` | TEXT | NO | — | — | Display name. | `Sarah Chen` |
| `account_number` | TEXT | NO | — (no FK) | — | Branch client number; matches `offline_clients.account_number`. | `4829157302` |
| `date_of_birth` | TEXT | NO | — | — | `YYYY-MM-DD`. | `1996-04-12` |
| `created_at` | TEXT | NO | — | `strftime('%Y-%m-%dT%H:%M:%SZ','now')` | Row creation time (UTC). | `2026-10-15T15:20:01Z` |
| `advisor_id` | TEXT | YES | FK → `advisors.id` (NO ACTION) | NULL | Assigned advisor; NULL = none yet (005). | `adv-1` |
| `mfa_method` | TEXT | NO | CHECK `IN ('sms','email')` | `'sms'` | How one-time codes are delivered (007). | `sms` |
| `terms_accepted_at` | TEXT | YES | — | NULL | When the client accepted the terms (007). | `2024-01-01T00:00:00Z` |

#### 5.1.3 Constraints
- `PRIMARY KEY (id)` → `sqlite_autoindex_users_1`.
- `UNIQUE (email) COLLATE NOCASE` → `sqlite_autoindex_users_2`. `'SARAH.CHEN@EXAMPLE.COM'` matches the seeded row; this was verified with `SELECT … WHERE email = 'SARAH.CHEN@EXAMPLE.COM'` → 1 row. Violation: `UNIQUE constraint failed: users.email`.
- `CHECK (mfa_method IN ('sms','email'))`.
- **Gotcha:** the `NOT NULL DEFAULT 'sms'` and CHECK on `mfa_method` were added by `ALTER TABLE … ADD COLUMN`. Existing rows took the default.

#### 5.1.4 Indexes
| Index | Columns | Purpose |
|---|---|---|
| `sqlite_autoindex_users_1` | `id` | PK lookups (`UserRepository.findById`) |
| `sqlite_autoindex_users_2` | `email` (NOCASE) | Login lookup (`UserRepository.findByEmail`, `RegistrationRepository.emailInUse`) |

#### 5.1.7 Relationships
**Outgoing:** `advisor_id → advisors.id` (ON DELETE NO ACTION).

**Incoming (18):**

| Source | Cascade |
|---|---|
| `user_profiles`, `user_preferences`, `sessions`, `accounts`, `documents`, `goals`, `portfolio_snapshots`, `asset_allocations`, `alerts`, `quick_links`, `notifications`, `education_progress`, `appointments`, `advisor_messages`, `watchlist`, `user_security_answers` | ON DELETE CASCADE |
| `offline_clients.enrolled_user_id`, `registrations.user_id` | NO ACTION (**blocks delete**) |

**Dependency analysis.** `DELETE FROM users WHERE id='emma'` on the seeded DB fails with `FOREIGN KEY constraint failed`, because every persona has an `offline_clients` row whose `enrolled_user_id` points at it (seed `107_registration.sql`). To hard-delete a user:
1. `UPDATE offline_clients SET enrolled_user_id = NULL WHERE enrolled_user_id = ?`
2. `UPDATE registrations SET user_id = NULL WHERE user_id = ?` (or delete those registrations)
3. `DELETE FROM users WHERE id = ?`. Everything else cascades. Verified on a copy: Emma's accounts and transactions dropped to 0.

#### 5.1.8 Special Behaviors
- Email comparison is case-insensitive because of the column collation, so no `LOWER()` is needed.
- No password hashing. This must change before any non-demo use (see § 12).

---

### `user_profiles` — `001:26`

- **Description:** 1:1 extension of `users` with contact, address and trusted-contact details. **Rows:** 6. Created at registration from the `offline_clients` record. The address is updated by `ProfileRepository` (`UPDATE user_profiles SET address_line1 …`).

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK, FK → `users.id` CASCADE | — | Owner. | `sarah` |
| `phone_masked` | TEXT | NO | — | — | Masked phone; only the last 2 digits are visible. | `+1 (416) •••-••42` |
| `sin_masked` | TEXT | YES | — | NULL | Masked Social Insurance Number. | `••• ••• 821` |
| `member_since` | INTEGER | NO | — | — | Year the client joined. | `2020` |
| `address_line1` | TEXT | NO | — | — | | `218 Queen Street West` |
| `address_line2` | TEXT | YES | — | NULL | | `Suite 1200` |
| `city` | TEXT | NO | — | — | | `Toronto` |
| `province` | TEXT | NO | — | — | Two-letter code (not enforced). | `ON` |
| `postal_code` | TEXT | NO | — | — | | `M5V 2A1` |
| `country` | TEXT | NO | — | — | Country name (not ISO code). | `Canada` |
| `trusted_contact_name` | TEXT | YES | — | NULL | | `David Chen` |
| `trusted_contact_relationship` | TEXT | YES | — | NULL | | `Sibling` |

Indexes: PK autoindex only. Note that `registrations` captures `trusted_contact_phone`/`email`, but `user_profiles` has **no columns for them**, so they are not carried over at completion.

---

### `user_preferences` — `001:41`

- **Description:** 1:1 notification, delivery, language, theme and meeting preferences. **Rows:** 6.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK, FK → `users.id` CASCADE | — | Owner | `sarah` |
| `notify_email` | INTEGER | NO | CHECK 0/1 | — (none) | Email alerts on | `1` |
| `notify_sms` | INTEGER | NO | CHECK 0/1 | — | SMS alerts on | `0` |
| `notify_push` | INTEGER | NO | CHECK 0/1 | — | Push alerts on | `1` |
| `document_delivery` | TEXT | NO | CHECK `IN ('digital','paper_and_digital')` | — | Statement delivery | `digital` |
| `language` | TEXT | NO | CHECK `IN ('en-CA','fr-CA')` | — | UI/content language | `en-CA` |
| `theme` | TEXT | NO | CHECK `IN ('light','dark','system')` | — | UI theme | `light` |
| `default_meeting_type` | TEXT | NO | CHECK `IN ('video','phone','in_person')` | — | Default advisor meeting type | `video` |

No column has a DEFAULT, so every INSERT must supply all eight values. Registration inserts `notify_email=1`, `notify_push=0`, `document_delivery='digital'`, `theme='system'`, `default_meeting_type='video'`, and `notify_sms` follows the MFA method.

---

### `sessions` — `001:53`

- **Description:** Access/refresh token pairs issued by the API. **Shared** between the Spring API and the Node API: "a token issued by the Node API also works here" (`SessionRepository` Javadoc). **Rows:** 0 after seed; grows by 1 per sign-in or refresh.
- **Volatility:** High. Rows are never deleted, only `revoked` or expired, so the table grows without bound (see § 17).

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `access_token` | TEXT | NO | PK | — | Bearer token. | `mock-at-9d44…` (`mock-at-<uuid>`) |
| `refresh_token` | TEXT | NO | UNIQUE | — | Refresh token. | `mock-rt-<uuid>` |
| `user_id` | TEXT | NO | FK → `users.id` CASCADE | — | Session owner | `sarah` |
| `mfa_verified` | INTEGER | NO | CHECK 0/1 | `0` | Second factor completed | `1` |
| `revoked` | INTEGER | NO | CHECK 0/1 | `0` | Signed out or rotated | `0` |
| `expires_at` | TEXT | NO | — | — | Expiry (UTC, ms). The API sets now + 900 s (`TOKEN_TTL_SECONDS`) and extends it when MFA is verified. | `2026-10-15T15:38:21.917Z` |
| `created_at` | TEXT | NO | — | **none** (supplied by the writer) | Issue time (UTC, ms) | `2026-10-15T15:23:19.707Z` |

| Index | Columns | Purpose |
|---|---|---|
| `sqlite_autoindex_sessions_1` | `access_token` | Bearer-token validation on every request (`findActive`) |
| `sqlite_autoindex_sessions_2` | `refresh_token` | Refresh rotation (`rotate`) |
| `ix_sessions_user` | `user_id` | Per-user lookups and the FK cascade from `users` |

**Behaviour:** refresh rotation runs in one transaction. It selects by `refresh_token AND revoked = 0`, sets `revoked = 1` on the old row, and inserts a new row (`SessionRepository.rotate`). Expiry is checked in Java (`Instant.parse(expiresAt)`), not in SQL.

---

## 5.B Accounts and Investments

### `accounts` — `001:69`

- **Description:** A client's investment account (registered plan or non-registered). **Rows:** 27. **Growth:** +1 when a client opens an account (`AccountRepository.open`).

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK part 1, FK → `users.id` CASCADE | — | Owner | `sarah` |
| `id` | TEXT | NO | PK part 2 | — | Account id, unique **per user**. Seeds use a short slug; the API generates `acct-<8 hex>`. | `tfsa` |
| `type` | TEXT | NO | CHECK `IN ('TFSA','RRSP','RESP','RDSP','FHSA','NON_REGISTERED','LIRA','RRIF')` | — | Canadian account type | `TFSA` |
| `display_name` | TEXT | NO | — | — | Product name | `Growth TFSA` |
| `nickname` | TEXT | YES | — | NULL | User-chosen label. A blank value is stored as NULL. | NULL |
| `balance` | INTEGER | NO | — | — | Market value (minor units) | `3241000` |
| `currency` | TEXT | NO | — | — | ISO-4217 code | `CAD` |
| `hidden` | INTEGER | NO | CHECK 0/1 | `0` | Hidden from lists and the portfolio total | `0` |
| `day_change` | INTEGER | YES | — | NULL | Today's change (minor units) | `21040` |
| `day_change_pct` | REAL | YES | — | NULL | Today's change, percent | `0.65` |
| `contribution_room` | INTEGER | YES | — | NULL | Remaining contribution room (minor units); NULL for non-registered or unknown. New TFSA = 700000, new FHSA = 800000. | `600000` |
| `tax_status` | TEXT | NO | — (not CHECKed) | — | Observed values: `Tax-free`, `Tax-deferred`, `Taxable` | `Tax-free` |
| `rate_of_return` | REAL | YES | — | NULL | Percent | `11.2` |
| `sort_order` | INTEGER | NO | — | `0` | Display order; new accounts get `MAX+1` | `1` |

**Indexes:** PK autoindex `(user_id, id)`. **Incoming FKs (CASCADE):** `holdings`, `transactions`, `account_performance`, `performance_points`, all through the composite `(user_id, account_id)`. `documents.account_id` is **not** an FK (see `documents`).

---

### `holdings` — `001:87`

- **Description:** A position held in an account. **Rows:** 81. Seed data only; no API writes.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK (with `account_id`) → `accounts(user_id,id)` CASCADE | — | Owner | `sarah` |
| `account_id` | TEXT | NO | PK 2, FK (composite) | — | Account | `tfsa` |
| `symbol` | TEXT | NO | PK 3 (**no FK** to `securities`) | — | Ticker | `XEQT.TO` |
| `name` | TEXT | NO | — | — | Security name (denormalised) | `iShares All-Equity ETF` |
| `quantity` | REAL | NO | — | — | Units held (fractional allowed) | `120` |
| `market_value` | INTEGER | NO | — | — | Minor units | `278560` |
| `currency` | TEXT | NO | — | — | ISO-4217 | `CAD` |
| `weight_pct` | REAL | NO | — | — | Share of the account, percent | `45` |

Indexes: PK autoindex `(user_id, account_id, symbol)`. Every seeded symbol exists in `securities`, verified with `NOT IN` → 0, but the database does not enforce this.

---

### `transactions` — `001:101`

- **Description:** Account activity. `status='posted'` is settled history; `status='scheduled'` is upcoming, such as auto-contributions. **Rows:** 216. Seed data only; no API writes.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK composite → `accounts` CASCADE | — | Owner | `sarah` |
| `account_id` | TEXT | NO | PK 2 | — | Account | `tfsa` |
| `id` | TEXT | NO | PK 3 | — | Unique per account (seeds reuse `sarah-t1` across accounts) | `t1` |
| `date` | TEXT | NO | — | — | ISO-8601 UTC timestamp at midnight | `2024-12-01T00:00:00Z` |
| `description` | TEXT | NO | — | — | Headline | `XEQT · Buy 12 units` |
| `detail` | TEXT | YES | — | NULL | Sub-line | `All-Equity ETF` |
| `type` | TEXT | NO | CHECK `IN ('contribution','buy','sell','dividend','fee','withdrawal','transfer','scheduled')` | — | Kind | `buy` |
| `amount` | INTEGER | NO | — | — | Signed minor units (negative = money out) | `-38412` |
| `currency` | TEXT | NO | — | — | ISO-4217 | `CAD` |
| `status` | TEXT | NO | CHECK `IN ('posted','scheduled')` | `'posted'` | Settlement state | `posted` |

| Index | Columns | Purpose |
|---|---|---|
| `sqlite_autoindex_transactions_1` | `(user_id, account_id, id)` | PK |
| `ix_transactions_account_date` | `(user_id, account_id, date DESC)` | Paged activity list `ORDER BY date DESC` (`listPostedTransactions`) |

Note that `type='scheduled'` and `status='scheduled'` are redundant in the seed: both are set on upcoming rows.

---

### `account_performance` — `001:118`

- **Description:** 1:1 performance summary per account. **Rows:** 27. When an account is opened, the API inserts `(0, 'CAD', 'S&P/TSX Composite')` so the account page does not error.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK composite → `accounts` CASCADE | — | | `sarah` |
| `account_id` | TEXT | NO | PK 2 | — | | `tfsa` |
| `time_weighted_return_pct` | REAL | NO | — | — | TWR, percent | `11.2` |
| `currency` | TEXT | NO | — | — | | `CAD` |
| `benchmark_name` | TEXT | NO | — | — | | `S&P/TSX Composite` |

---

### `performance_points` — `001:129`

- **Description:** Chart series per account. `series='account'` values are **minor units**; `series='benchmark'` values are an **index (start = 100)**. **Rows:** 189.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK composite → `accounts` CASCADE | — | | `sarah` |
| `account_id` | TEXT | NO | PK 2 | — | | `tfsa` |
| `series` | TEXT | NO | PK 3, CHECK `IN ('account','benchmark')` | — | Which line | `account` |
| `period` | TEXT | NO | PK 4 | — | `YYYY-MM` | `2024-03` |
| `value` | REAL | NO | — | — | Minor units or index (see above) | `2810000` / `108.4` |

---

## 5.C Documents

### `documents` — `001:143`

- **Description:** Statements, tax slips, confirmations and legal documents. **Rows:** 42. Seed data only.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `id` | TEXT | NO | PK 2 | — | Unique per user | `d1` |
| `name` | TEXT | NO | — | — | Title | `2024 T5 Tax Slip` |
| `category` | TEXT | NO | — (not CHECKed) | — | Observed: `Tax`, `Statements`, `Confirmations`, `Legal` | `Tax` |
| `year` | INTEGER | NO | — | — | Tax/statement year | `2024` |
| `account_id` | TEXT | YES | — (**no FK**) | NULL | Related account; NULL = all accounts | `tfsa` |
| `account_label` | TEXT | YES | — | NULL | Denormalised account name | `Growth TFSA` / `All accounts` |
| `size_bytes` | INTEGER | NO | — | — | File size | `219136` |
| `action_required` | INTEGER | NO | CHECK 0/1 | `0` | Needs a signature or action | `1` |
| `url` | TEXT | NO | — | — | Mock signed URL | `mock://signed/d1` |

Indexes: PK autoindex only. Listing filters `user_id` plus optional `year`/`category` and sorts `year DESC, action_required DESC, id`. That is a partial PK scan plus an in-memory sort, which is fine at about 7 rows per user.

### `document_shares` — `003_document_shares.sql:5`

- **Description:** Audit record of a secure link sent to an outside recipient (for example an accountant). The API sets `expires_at` 7 days out. **Rows:** 0 after seed; append-only.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | INTEGER | NO | PK AUTOINCREMENT (rowid) | auto | Surrogate key; the only integer PK in the schema | `1` |
| `user_id` | TEXT | NO | FK (with `document_id`) → `documents(user_id,id)` CASCADE | — | | `sarah` |
| `document_id` | TEXT | NO | FK composite | — | | `d1` |
| `recipient` | TEXT | NO | — | — | Email address (not validated in the database) | `cpa@example.com` |
| `created_at` | TEXT | NO | — | — | | `2026-10-15T15:30:00Z` |
| `expires_at` | TEXT | NO | — | — | Link expiry | `2026-10-22T15:30:00Z` |

Index: `ix_document_shares_document (user_id, document_id)`. It supports the FK cascade from `documents`, and any future "shares for this document" query.

---

## 5.D Goals and Dashboard

### `goals` — `001:161`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `id` | TEXT | NO | PK 2 | — | Seeds use `goal-N`; the API generates new ids | `goal-1` |
| `name` | TEXT | NO | — | — | | `Home Down Payment` |
| `category` | TEXT | NO | CHECK `IN ('Education','Vacation','Home','Retirement','Safety')` | — | | `Home` |
| `current_amount` | INTEGER | NO | — | — | Minor units | `3840000` |
| `target_amount` | INTEGER | NO | — | — | Minor units | `8000000` |
| `currency` | TEXT | NO | — | — | | `CAD` |
| `target_date` | TEXT | NO | — | — | `YYYY-MM-DD` | `2027-06-30` |
| `progress_pct` | REAL | NO | — | — | Stored (not computed) percent | `48` |
| `show_on_dashboard` | INTEGER | NO | CHECK 0/1 | `0` | Pin to dashboard | `1` |
| `sort_order` | INTEGER | NO | — | `0` | New goals get `MAX+1` | `1` |

**Rows:** 18. Written by `GoalRepository.create` in a `@Transactional` block (it reads `MAX(sort_order)` and then INSERTs). `progress_pct` is denormalised and can drift from `current_amount/target_amount`.

### `portfolio_snapshots` — `001:178`

1:1 per user; portfolio-level figures that are **not** derived from account balances. Total value is computed by the API from visible `accounts.balance`. **Rows:** 6.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK, FK → `users.id` CASCADE | — | | `sarah` |
| `currency` | TEXT | NO | — | — | | `CAD` |
| `day_change` | INTEGER | NO | — | — | Minor units | `42100` |
| `day_change_pct` | REAL | NO | — | — | Percent | `0.7` |
| `as_of` | TEXT | NO | — | — | UTC timestamp | `2024-12-01T14:30:00Z` |

### `asset_allocations` — `001:186`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `asset_class` | TEXT | NO | PK 2 (not CHECKed) | — | Observed: `Equity`, `Fixed Income`, `Cash`, `Alternatives` | `Equity` |
| `pct` | REAL | NO | — | — | Percent of portfolio (sum ≈ 100 is not enforced) | `62.5` |
| `sort_order` | INTEGER | NO | — | `0` | | `1` |

**Rows:** 19.

### `alerts` — `001:194`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `id` | TEXT | NO | PK 2 | — | | `al-1` |
| `type` | TEXT | NO | CHECK `IN ('ACTION_REQUIRED','INFO','SUCCESS','WARNING')` | — | Severity | `ACTION_REQUIRED` |
| `title` | TEXT | NO | — | — | | `Sign your 2024 tax form` |
| `deep_link` | TEXT | YES | — | NULL | In-app link | `electricwealth://documents/d1` |

**Rows:** 6. Dashboard banner alerts, distinct from `notifications`.

### `quick_links` — `001:203`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `sort_order` | INTEGER | NO | PK 2 | — (none) | Position, which doubles as the key | `1` |
| `label` | TEXT | NO | — | — | English label; the API localises it | `Open account` |
| `deep_link` | TEXT | NO | — | — | | `electricwealth://accounts/new` |

**Rows:** 11. Registration inserts starter links.

---

## 5.E Notifications

### `notifications` — `002_notifications.sql:4`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `id` | TEXT | NO | PK 2 | — | Unique per user; registration uses `welcome` | `no1` |
| `title` | TEXT | NO | — | — | | `Sign your 2024 tax form` |
| `body` | TEXT | NO | — | — | | `Action required before Feb 28.` |
| `type` | TEXT | NO | CHECK `IN ('ACTION_REQUIRED','INFO','SUCCESS','WARNING')` | — | | `ACTION_REQUIRED` |
| `created_at` | TEXT | NO | — | — | | `2024-12-01T13:30:00Z` |
| `read` | INTEGER | NO | CHECK 0/1 | `0` | Read flag; set by mark-read and mark-all-read | `0` |

| Index | Columns | Purpose |
|---|---|---|
| PK autoindex | `(user_id, id)` | Mark one read |
| `ix_notifications_user_created` | `(user_id, created_at DESC)` | Inbox `ORDER BY created_at DESC` |

**Rows:** 16.

---

## 5.F Learning Centre

### `education_content` — `004_education.sql:6`

Bilingual course catalogue (reference data). **Rows:** 6.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | | `e1` |
| `title_en` | TEXT | NO | — | — | | `Investing 101: Getting started` |
| `title_fr` | TEXT | NO | — | — | | `Placements 101 : premiers pas` |
| `level` | TEXT | NO | CHECK `IN ('beginner','intermediate','advanced')` | — | | `beginner` |
| `type` | TEXT | NO | CHECK `IN ('class','challenge')` | — | | `class` |
| `duration_min` | INTEGER | NO | CHECK `> 0` | — | Minutes | `8` |
| `sort_order` | INTEGER | NO | — | `0` | | `1` |

### `education_progress` — `004:17`

Per-user progress. **No row means not started (0%).** **Rows:** 14. Upserted with `INSERT … ON CONFLICT (user_id, content_id) DO UPDATE`.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `content_id` | TEXT | NO | PK 2, FK → `education_content.id` CASCADE | — | | `e2` |
| `progress_pct` | INTEGER | NO | CHECK `BETWEEN 0 AND 100` | — | Whole percent (unlike the REAL `_pct` columns) | `60` |
| `updated_at` | TEXT | NO | — | — | | `2024-11-30T12:00:00Z` |

### `glossary_terms` — `004:25`

Bilingual glossary (reference data). **Rows:** 7. Searched with `LIKE ? ESCAPE '\'` and sorted in Java with a locale `Collator`, because SQLite's NOCASE ordering puts `é` after `z`.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | Slug | `asset-allocation` |
| `term_en` / `term_fr` | TEXT | NO | — | — | Term | `Asset allocation` / `Répartition de l’actif` |
| `definition_en` / `definition_fr` | TEXT | NO | — | — | Definition | |
| `sort_order` | INTEGER | NO | — | `0` | | `1` |

---

## 5.G Advisor

### `advisors` — `005_advisor.sql:4`

Reference data. **Rows:** 1 (`adv-1`, Jordan Avery, CFP).

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | | `adv-1` |
| `name` | TEXT | NO | — | — | | `Jordan Avery` |
| `designation` | TEXT | YES | — | NULL | Professional designation | `CFP` |
| `available` | INTEGER | NO | CHECK 0/1 | `1` | If 0, the API offers no slots | `1` |

**Incoming FKs (all NO ACTION):** `users.advisor_id`, `appointments.advisor_id`, `advisor_messages.advisor_id`, `offline_clients.advisor_id`. An advisor that is still referenced cannot be deleted.

### `appointments` — `005:15`

Booked meetings. `date` is a calendar date and `time` a 24-hour `HH:MM` start, **both in Toronto local time** (the one exception to the UTC rule). **Rows:** 1.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK (global, not per-user) | — | `appt-<8 hex>` | `appt-sarah-1` |
| `user_id` | TEXT | NO | FK → `users.id` CASCADE | — | Client | `sarah` |
| `advisor_id` | TEXT | NO | FK → `advisors.id` NO ACTION | — | | `adv-1` |
| `meeting_type` | TEXT | NO | CHECK `IN ('video','phone','in_person')` | — | | `video` |
| `date` | TEXT | NO | — | — | `YYYY-MM-DD` (Toronto) | `2024-12-05` |
| `time` | TEXT | NO | — | — | `HH:MM` (Toronto); the API offers `09:00, 10:30, 12:00, 14:30, 16:00` | `14:30` |
| `status` | TEXT | NO | CHECK `IN ('scheduled','completed','cancelled')` | `'scheduled'` | Cancelling sets `cancelled` (no delete) | `completed` |
| `notes` | TEXT | YES | — | NULL | Agenda | `FHSA allocation for the house goal` |
| `created_at` | TEXT | NO | — | — | UTC | `2024-12-01T11:30:00Z` |

| Index | Columns | Purpose |
|---|---|---|
| PK autoindex | `id` | |
| `ix_appointments_user` | `(user_id, date, time)` | "My appointments" `ORDER BY date, time` |
| `ux_appointments_advisor_slot` | `(advisor_id, date, time) WHERE status = 'scheduled'` | **Partial unique index: an advisor can have only one scheduled meeting per slot.** Cancelled and completed rows do not block the slot. |

**Concurrency contract:** the API checks availability first, but the partial unique index is the real guard. A losing INSERT or UPDATE fails with `UNIQUE constraint failed: appointments.advisor_id, appointments.date, appointments.time` (verified), which `AdvisorController.bookingSlot` maps to HTTP 409 `SLOT_UNAVAILABLE`.

### `advisor_messages` — `005:32`

Secure message thread between a client and their advisor. **Rows:** 13. Append-only.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK (global) | — | Seeds use a user-prefixed id; the API uses `msg-<8 hex>` | `sarah-m1` |
| `user_id` | TEXT | NO | FK → `users.id` CASCADE | — | Client | `sarah` |
| `advisor_id` | TEXT | NO | FK → `advisors.id` NO ACTION | — | | `adv-1` |
| `sender` | TEXT | NO | CHECK `IN ('advisor','client')` | — | | `client` |
| `text` | TEXT | NO | — | — | Message body | |
| `sent_at` | TEXT | NO | — | — | UTC | `2024-12-01T13:02:00Z` |

Index: `ix_advisor_messages_user (user_id, sent_at)` supports the thread query `ORDER BY sent_at, id`.

---

## 5.H Market Data (static demo data)

### `securities` — `006_market.sql:5`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `symbol` | TEXT | NO | PK | — | Ticker, with `.TO` for TSX | `XEQT.TO`, `AAPL` |
| `name` | TEXT | NO | — | — | | `iShares All-Equity ETF` |
| `exchange` | TEXT | NO | — | — | | `TSX`, `NASDAQ` |
| `currency` | TEXT | NO | — | — | Currency the security trades in | `CAD`, `USD` |
| `price` | INTEGER | NO | — | — | Last price (minor units) | `3482` |
| `change` | INTEGER | NO | — | — | Change since the previous close (minor units) | `15` |
| `change_pct` | REAL | NO | — | — | Percent | `0.42` |
| `about` | TEXT | YES | — | NULL | Description | |

**Rows:** 6. Incoming FKs (CASCADE): `price_history`, `watchlist`.

### `price_history` — `006:17`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `symbol` | TEXT | NO | PK 1, FK → `securities.symbol` CASCADE | — | | `XEQT.TO` |
| `range` | TEXT | NO | PK 2, CHECK `IN ('1D','1M','1Y','5Y')` | — | Chart range | `1D` |
| `t` | TEXT | NO | PK 3 | — | `HH:MM` for 1D, `YYYY-MM-DD` for 1M, `YYYY-MM` for 1Y and 5Y | `09:30` |
| `close` | INTEGER | NO | — | — | Closing price (minor units) | `3467` |

**Rows:** 408 (generated random walk). Read with `WHERE symbol = ? AND range = ? ORDER BY t`, which is served entirely by the PK.

### `watchlist` — `006:25`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | `sarah` |
| `symbol` | TEXT | NO | PK 2, FK → `securities.symbol` CASCADE | — | | `AAPL` |
| `added_at` | TEXT | NO | — | — | UTC | `2024-11-01T00:00:00Z` |

**Rows:** 30. Add is idempotent (`ON CONFLICT (user_id, symbol) DO NOTHING`); remove is a hard `DELETE`.

### `market_news` — `006:32`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | | `n1` |
| `title` | TEXT | NO | — | — | | |
| `source` | TEXT | NO | — | — | Publisher | `Reuters` |
| `published_at` | TEXT | NO | — | — | UTC | `2024-12-01T12:00:00Z` |
| `tag` | TEXT | YES | — | NULL | Topic | `Rates` |

**Rows:** 3.

### `market_roundup_items` — `006:40`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | | `r1` |
| `week_of` | TEXT | NO | — | — | `YYYY-MM-DD`, "the Monday-or-Sunday date the roundup covers" | `2024-12-01` |
| `title` | TEXT | NO | — | — | | |
| `summary` | TEXT | NO | — | — | | |
| `published_at` | TEXT | NO | — | — | UTC | `2024-12-01T08:00:00Z` |

**Rows:** 3. The API shows only the latest `week_of` (`SELECT MAX(week_of)`), which is an unindexed full scan; harmless at this size.

### `baskets` — `006:49`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | | `b1` |
| `name` | TEXT | NO | — | — | | `Clean Energy` |
| `description` | TEXT | NO | — | — | | |
| `return_1y_pct` | REAL | NO | — | — | Percent | |
| `holdings_count` | INTEGER | NO | — | — | Number of securities in the theme (no child table) | |
| `risk` | TEXT | NO | CHECK `IN ('Low','Medium','High')` | — | | `High` |
| `sort_order` | INTEGER | NO | — | `0` | | `1` |

**Rows:** 4.

---

## 5.I Online Enrolment

### `offline_clients` — `007_registration.sql:6`

- **Description:** Branch or advisor client records. A client proves who they are online (account number + postal code + date of birth) and then becomes a `users` row. **Rows:** 8: 2 not yet enrolled (`Priya Patel` 7391046285, `Marc Tremblay` 2654819370) and 6 personas marked enrolled.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `account_number` | TEXT | NO | PK | — | Branch client number | `7391046285` |
| `name` | TEXT | NO | — | — | | `Priya Patel` |
| `date_of_birth` | TEXT | NO | — | — | `YYYY-MM-DD`; exact-match identity check | `1990-02-17` |
| `phone_masked` | TEXT | NO | — | — | | `+1 (613) •••-••24` |
| `sin_masked` | TEXT | YES | — | NULL | | `••• ••• 337` |
| `client_since` | INTEGER | NO | — | — | Year | `2019` |
| `address_line1` | TEXT | NO | — | — | | `150 Elgin Street` |
| `address_line2` | TEXT | YES | — | NULL | | `Suite 1200` |
| `city` | TEXT | NO | — | — | | `Ottawa` |
| `province` | TEXT | NO | — | — | | `ON` |
| `postal_code` | TEXT | NO | — | — | Stored as `A1A 1A1`; compared with whitespace removed and upper-cased in Java | `K1P 5G4` |
| `country` | TEXT | NO | — | — | | `Canada` |
| `language` | TEXT | NO | CHECK `IN ('en-CA','fr-CA')` | — | Copied to `user_preferences.language` | `fr-CA` |
| `advisor_id` | TEXT | YES | FK → `advisors.id` NO ACTION | NULL | Copied to `users.advisor_id` | `adv-1` |
| `enrolled_user_id` | TEXT | YES | FK → `users.id` NO ACTION | NULL | Set once the client has registered online | `sarah` |

**Gotcha:** `enrolled_user_id` has no ON DELETE action, so it **blocks deleting the linked user** (see `users`). It is set by the seed for the personas and by `RegistrationRepository.complete` (`UPDATE offline_clients SET enrolled_user_id = ? …`, `RegistrationRepository.java:192`) in the same transaction that creates the user. Nothing in the database prevents a second registration against an `offline_clients` row that is already enrolled; that check, if any, is in the API.

### `security_questions` — `007:24`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | | `q1` |
| `text_en` / `text_fr` | TEXT | NO | — | — | Question text | `What was the name of your first pet?` |
| `sort_order` | INTEGER | NO | — | `0` | | `1` |

**Rows:** 5. Reference data. Incoming FKs (NO ACTION) from both answer tables.

### `registrations` — `007:32`

- **Description:** One in-progress or finished online registration. "Steps fill in columns in order." The API sets `expires_at` 30 minutes out (`REGISTRATION_TTL`). A registration is *open* when `user_id IS NULL AND expires_at > now`, which is checked in Java. **Rows:** 0 after seed; rows are never deleted.

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `id` | TEXT | NO | PK | — | `reg-<8 hex>` | `reg-1a2b3c4d` |
| `email` | TEXT | NO | `COLLATE NOCASE` (**not** UNIQUE) | — | Chosen login email | |
| `password` | TEXT | NO | — | — | **Demo only: plain text** | |
| `account_number` | TEXT | YES | FK → `offline_clients.account_number` NO ACTION | NULL | Set when identity is verified (step 2) | `7391046285` |
| `trusted_contact_name` | TEXT | YES | — | NULL | | |
| `trusted_contact_relationship` | TEXT | YES | — | NULL | | |
| `trusted_contact_phone` | TEXT | YES | — | NULL | Not carried to `user_profiles` | |
| `trusted_contact_email` | TEXT | YES | — | NULL | Not carried to `user_profiles` | |
| `security_answers_saved` | INTEGER | NO | CHECK 0/1 | `0` | Step flag | `1` |
| `mfa_method` | TEXT | YES | CHECK `IN ('sms','email')` | NULL | Chosen code method | `email` |
| `consented_at` | TEXT | YES | — | NULL | Terms consent time | |
| `user_id` | TEXT | YES | FK → `users.id` NO ACTION | NULL | Set when completed | `u-1a2b3c4d` |
| `created_at` | TEXT | NO | — | — | UTC | |
| `expires_at` | TEXT | NO | — | — | UTC; created + 30 min | |

Indexes: PK autoindex only. `account_number` and `user_id` are FK columns without indexes (see § 7.4).

### `registration_security_answers` — `007:50`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `registration_id` | TEXT | NO | PK 1, FK → `registrations.id` CASCADE | — | | |
| `question_id` | TEXT | NO | PK 2, FK → `security_questions.id` NO ACTION | — | | `q1` |
| `answer` | TEXT | NO | — | — | **Normalised:** trimmed, lower-cased, inner whitespace collapsed (Java `normaliseAnswer`). Stored in plain text. | `fluffy` |

Saving deletes and re-inserts all answers for the registration in one transaction.

### `user_security_answers` — `007:57`

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `user_id` | TEXT | NO | PK 1, FK → `users.id` CASCADE | — | | |
| `question_id` | TEXT | NO | PK 2, FK → `security_questions.id` NO ACTION | — | | `q1` |
| `answer` | TEXT | NO | — | — | Normalised answer copied from the registration at completion (`INSERT … SELECT`) | |

**Rows:** 0 (personas have none).

---

## 5.J Infrastructure

### `schema_migrations` — created by `scripts/lib.js migrate()`, not by a migration file

| Column | Type | Nullable | Constraint | Default | Business Definition | Example |
|---|---|---|---|---|---|---|
| `version` | TEXT | NO | PK | — | Migration **file name** | `005_advisor.sql` |
| `applied_at` | TEXT | NO | — | `strftime('%Y-%m-%dT%H:%M:%SZ','now')` | When applied | |

**Rows:** 7. See § 15.
