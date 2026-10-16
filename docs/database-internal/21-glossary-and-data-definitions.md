---
slug: glossary-and-data-definitions
title: "Glossary and Data Definitions"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 27. Glossary and Data Definitions

### Domain Terms

| Term | Definition | Where in schema |
|------|-----------|---------|
| **TFSA** | Tax-Free Savings Account (Canada). Growth and withdrawals are tax-free. | `accounts.type = 'TFSA'` |
| **RRSP** | Registered Retirement Savings Plan. Contributions are deductible; growth is tax-deferred. | `accounts.type = 'RRSP'` |
| **RESP** | Registered Education Savings Plan. Eligible for the CESG grant. | `accounts.type = 'RESP'` |
| **RDSP** | Registered Disability Savings Plan | `accounts.type = 'RDSP'` |
| **FHSA** | First Home Savings Account | `accounts.type = 'FHSA'` |
| **LIRA** | Locked-In Retirement Account (pension money) | `accounts.type = 'LIRA'` |
| **RRIF** | Registered Retirement Income Fund (RRSP conversion that pays out) | `accounts.type = 'RRIF'` |
| **Non-registered** | Taxable investment account | `accounts.type = 'NON_REGISTERED'` |
| **Contribution room** | Amount still allowed to be deposited into a registered plan this year | `accounts.contribution_room` (minor units) |
| **Holding** | A position (security + quantity) inside an account | `holdings` |
| **Posted / scheduled transaction** | Settled history vs. upcoming (e.g. auto-contribution) | `transactions.status` |
| **TWR (time-weighted return)** | Return that neutralises the effect of deposits and withdrawals | `account_performance.time_weighted_return_pct` |
| **Benchmark index** | Comparison series normalised to 100 at the start | `performance_points.series = 'benchmark'` |
| **Persona** | One of 6 fictional demo clients (`sarah`, `michael`, `linda`, `david`, `emma`, `foster`) | `seed/001–006` |
| **Offline client** | A client opened by a branch or advisor who has not (or has) enrolled online | `offline_clients` |
| **Enrolment / registration** | Online sign-up flow that turns an offline client into a `users` row | `registrations`, `RegistrationRepository.complete` |
| **Advisor slot** | A bookable meeting start time (`09:00, 10:30, 12:00, 14:30, 16:00` Toronto, weekdays, next 5 business days) | `appointments.date/time`; slots are defined in the API, not in a table |
| **Basket** | Ready-made thematic group of securities | `baskets` |
| **Roundup** | Weekly market summary items | `market_roundup_items.week_of` |

### Data Conventions

| Term | Definition | Example |
|------|-----------|---------|
| **Minor units** | Integer amount in the currency's smallest unit (cents) | `3241000` CAD = $32,410.00 |
| **`_pct`** | Percent as REAL, where `0.65` = 0.65% (except `education_progress.progress_pct`: INTEGER 0–100) | `day_change_pct = 0.65` |
| **`_masked`** | Value stored already masked; the full value is never stored | `••• ••• 821` |
| **ISO-8601 UTC TEXT** | `YYYY-MM-DDTHH:MM:SSZ` (or with `.sss`) | `2024-12-01T13:30:00Z` |
| **Toronto local** | `appointments.date` (`YYYY-MM-DD`) + `time` (`HH:MM`) | `2024-12-05` `14:30` |
| **Deep link** | In-app URI | `electricwealth://documents/d1` |
| **Tenant-scoped id** | An id that is unique only within one `user_id` | `accounts.id = 'tfsa'` |

### Database Terms

| Term | Definition | Example |
|------|-----------|---------|
| **Composite PK** | Primary key over several columns | `(user_id, account_id, id)` on `transactions` |
| **ON DELETE CASCADE** | Deleting the parent deletes the children | `accounts` → `holdings` |
| **NO ACTION** | SQLite default FK action: the delete fails at statement end if children exist | `offline_clients.enrolled_user_id → users` |
| **Partial index** | Index over the subset of rows matching a WHERE clause | `ux_appointments_advisor_slot … WHERE status='scheduled'` |
| **`COLLATE NOCASE`** | ASCII case-insensitive comparison and uniqueness | `users.email` |
| **`sqlite_autoindex_*`** | Index SQLite creates automatically for a PK or UNIQUE constraint | `sqlite_autoindex_users_2` (email) |
| **Rollback journal** | SQLite's default (`journal_mode=delete`) atomic-commit mechanism; one writer locks the file | — |
| **`PRAGMA foreign_keys`** | Per-connection switch for FK enforcement (OFF by default) | Set by both the scripts and the API |
| **Migration ledger** | `schema_migrations`, the record of applied migration files | `005_advisor.sql` |
