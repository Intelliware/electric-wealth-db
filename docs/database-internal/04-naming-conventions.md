---
slug: naming-conventions
title: "Naming Conventions"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 4. Naming Conventions

These conventions are **observed** across migrations 001–007. Apart from the four data-type conventions in the `001_initial_schema.sql` header comment (money, booleans, dates, composite keys), no written naming standard exists.

### 4.1 Table Naming

**Convention:** lowercase `snake_case`, plural noun.

**Examples in this schema:**
```
users, accounts, holdings, transactions, documents, goals, notifications    -- plural entities
user_profiles, user_preferences, user_security_answers                      -- <owner>_<plural> for per-user extensions
account_performance                                                         -- singular mass noun (one row per account)
watchlist                                                                   -- singular collective noun (exception)
price_history                                                               -- mass noun (exception)
```

**Special patterns:**
- **Per-user satellite tables (1:1):** `user_<aspect>`, e.g. `user_profiles`, `user_preferences`.
- **Child-of-parent tables:** `<parent>_<child>`, e.g. `document_shares`, `advisor_messages`, `registration_security_answers`, `market_roundup_items`.
- **Reference/catalogue tables:** plain plural nouns with no `_ref` suffix: `advisors`, `securities`, `security_questions`, `education_content`, `glossary_terms`, `baskets`.
- **Infrastructure:** `schema_migrations` (migration ledger).
- No prefixes (`tbl_`) and no audit or archive tables.

### 4.2 Column Naming

**Convention:** lowercase `snake_case`, descriptive.

**Special patterns (observed):**
- **Primary keys:** the bare name `id` (e.g. `accounts.id`, `advisors.id`) or a natural key (`securities.symbol`, `offline_clients.account_number`, `sessions.access_token`). Tenant-scoped tables combine `user_id` with `id`.
- **Foreign keys:** `<referenced_singular>_id`, e.g. `user_id`, `account_id`, `advisor_id`, `document_id`, `content_id`, `question_id`, `registration_id`. Exceptions: `enrolled_user_id` (role-named), `account_number` and `symbol` (natural keys).
- **Booleans:** bare adjective or verb, **not** `is_`/`has_`: `hidden`, `read`, `revoked`, `available`, `mfa_verified`, `action_required`, `show_on_dashboard`, `security_answers_saved`, `notify_email`/`notify_sms`/`notify_push`.
- **Timestamps:** `<verb>_at`: `created_at`, `updated_at`, `expires_at`, `sent_at`, `added_at`, `published_at`, `consented_at`, `terms_accepted_at`. Exceptions: `as_of`, `week_of`, `date`, `time`, `t`.
- **Money:** the bare noun with no unit suffix (`balance`, `amount`, `market_value`, `price`, `close`, `current_amount`, `target_amount`, `day_change`, `contribution_room`). The unit is always minor units of the row's `currency`.
- **Percentages:** `_pct` suffix (`day_change_pct`, `weight_pct`, `progress_pct`, `return_1y_pct`, `time_weighted_return_pct`) stored as REAL percent (`0.65` means 0.65%), **except** `education_progress.progress_pct`, which is INTEGER 0–100.
- **Localised text:** `_en` / `_fr` suffix pairs (`title_en`/`title_fr`, `term_en`/`term_fr`, `definition_en`/`definition_fr`, `text_en`/`text_fr`).
- **Ordering:** `sort_order INTEGER NOT NULL DEFAULT 0` on every user-ordered or catalogue table.
- **Masked PII:** `_masked` suffix (`phone_masked`, `sin_masked`). Only masked values are stored.
- **Reserved-word-ish names in use:** `date`, `time`, `read`, `range`, `text`, `type`, `change`, `close`. All are legal unquoted in SQLite, but quote them when porting to another engine.

### 4.3 Constraint Naming

Inline constraints are **not named**. SQLite generates names for PKs and UNIQUE constraints (`sqlite_autoindex_<table>_<n>`), and CHECK/FK violations report the expression or columns, not a name. Only explicit indexes have names:

| Constraint Type | Naming Convention | Example |
|-----------------|-------------------|---------|
| **Primary key** | unnamed (inline `PRIMARY KEY`) | → `sqlite_autoindex_accounts_1` |
| **Foreign key** | unnamed (inline `REFERENCES` / table-level `FOREIGN KEY`) | error text: `FOREIGN KEY constraint failed` |
| **Unique constraint (inline)** | unnamed | `users.email UNIQUE` → `sqlite_autoindex_users_2` |
| **Unique index** | `ux_<table>_<purpose>` | `ux_appointments_advisor_slot` |
| **Non-unique index** | `ix_<table>_<columns-or-purpose>` | `ix_transactions_account_date`, `ix_sessions_user` |
| **Check constraint** | unnamed (inline `CHECK`) | error text: `CHECK constraint failed: type IN ('TFSA', …)` |
| **Default** | unnamed (inline `DEFAULT`) | — |

### 4.4 Migration File Naming

`NNN_<snake_case_description>.sql`, a three-digit sequence (`001_initial_schema.sql` … `007_registration.sql`). Seed files use `NNN_<persona>.sql` for per-persona data (001–006) and `1NN_<feature>.sql` for feature data, where `1NN` mirrors the migration number (`102_notifications.sql` matches migration `002`).
