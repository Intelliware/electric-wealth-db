---
slug: reference-and-seed-data
title: "Reference and Seed Data"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 14. Reference and Seed Data

### 14.1 Reference Tables (Lookup Tables)

There are no `_ref` lookup tables. Fixed enumerations (account types, transaction types, statuses, languages, themes) are **CHECK constraints** (§ 6.5); changing one requires a migration. The following tables hold slowly changing **catalogue** data that is loaded only by seed files and never written by the API:

| Table | Purpose | Rows | Update frequency | Example values |
|-------|---------|------|------------------|-----------------|
| `advisors` | Advisors who can be assigned to clients | 1 | Seed only | `adv-1` Jordan Avery, CFP |
| `security_questions` | Enrolment security questions (EN/FR) | 5 | Seed only | `q1` "What was the name of your first pet?" |
| `education_content` | Learning-centre course catalogue (EN/FR) | 6 | Seed only | `e1` "Investing 101: Getting started" |
| `glossary_terms` | Glossary (EN/FR) | 7 | Seed only | `etf` / `FNB` |
| `securities` | Static market quotes | 6 | Seed only | `XEQT.TO`, `VFV.TO`, `SHOP.TO`, `NA.TO`, `AAPL`, `ZAG.TO` |
| `price_history` | Generated price series per security and range | 408 | Seed only | `('XEQT.TO','1D','09:30',3467)` |
| `market_news` | Headlines | 3 | Seed only | `n1` Reuters, tag `Rates` |
| `market_roundup_items` | Weekly roundup | 3 | Seed only | `week_of = '2024-12-01'` |
| `baskets` | Thematic baskets | 4 | Seed only | `Clean Energy` (High), `Canadian Dividend` (Low) |
| `offline_clients` | Branch client records eligible for online enrolment | 8 | Seed; `enrolled_user_id` is also set by the API at registration | `7391046285` Priya Patel (not enrolled) |

**Querying reference data:**
```sql
-- Localised catalogue (the API picks the _en or _fr column from Accept-Language)
SELECT id, title_fr AS title, level, type, duration_min FROM education_content ORDER BY sort_order, id;

-- Valid account types live in the DDL, not in a table:
SELECT sql FROM sqlite_master WHERE name = 'accounts';
```

**Application pattern:** the Spring API mirrors the CHECK enumerations as Java enums (`dto/ApiEnums.java`, mapped via `config/JsonEnums.java`). Adding a value needs **both** a migration (to rebuild the CHECK) **and** an enum change. In SQLite, changing a CHECK requires recreating the table (§ 15).

### 14.2 Seed Data

**Location:** `seed/`. **Loader:** `scripts/lib.js seed()`, run by `npm run db:seed` or as part of `npm run db:reset`.

**Files (applied in file-name order, all in ONE transaction):**

| File | Loads | Notes |
|---|---|---|
| `001_sarah.sql` | Persona *Sarah Chen* (`sarah`, b. 1996): user, profile, preferences, 4 accounts (TFSA, RRSP, FHSA, non-registered), holdings, transactions, performance, documents, goals, snapshot, allocations, alerts, quick links | "Generated from v1 ElectricWealthAIDE server seed data." |
| `002_michael.sql` | *Michael Thompson* (`michael`, b. 1982) | 5 accounts incl. 2 × RESP |
| `003_linda.sql` | *Linda Rodriguez* (`linda`, b. 1966) | 5 accounts incl. LIRA, RRIF |
| `004_david.sql` | *David Kim* (`david`, b. 1976) | 5 accounts incl. RDSP; largest total (~$1.2M) |
| `005_emma.sql` | *Emma Wilson* (`emma`, b. 2000) | 4 accounts; smallest total (~$43K) |
| `006_foster.sql` | *Robert & Margaret Foster* (`foster`, b. 1956) | 4 accounts incl. 2 × RRIF |
| `102_notifications.sql` | 16 notifications across personas | For migration 002 |
| `104_education.sql` | Catalogue, glossary, per-persona progress | For migration 004; the French text is new |
| `105_advisor.sql` | `adv-1`, `UPDATE users SET advisor_id = 'adv-1'` (all users), 1 completed appointment, 13 messages | For migration 005 |
| `106_market.sql` | Securities, generated price history, watchlists, news, roundup, baskets | For migration 006; price history is a random walk |
| `107_registration.sql` | 5 security questions; 2 un-enrolled branch clients; branch records for the 6 personas, created with `INSERT … SELECT` from `users`/`user_profiles`/`user_preferences` and marked enrolled; `UPDATE users SET terms_accepted_at = '2024-01-01T00:00:00Z'` | For migration 007 |

**Demo credentials (all personas):** password `Demo123!`, MFA code `123456`. Emails are `<first>.<last>@example.com`, e.g. `sarah.chen@example.com`; the Fosters use `robert.foster@example.com`.

**Ordering dependency:** the `1NN_` files assume the persona files ran first. `105` updates every user's `advisor_id`, and `107` copies persona data into `offline_clients`. A **new persona file added after 105/107 in sort order would miss these updates**, so new persona seeds must use a number below `100`.

**Idempotency guard:** `seed()` refuses to run if `users` already has rows ("Database already has N user(s); skipping seed"). `--force` bypasses the guard, but the seed files are plain `INSERT`s and would then fail on duplicate primary keys. In practice, re-seeding means `npm run db:reset`.

**Running seed data:**
```bash
npm run db:reset          # delete file → migrate → seed (normal path)
npm run db:seed           # seed an empty, migrated DB
npm run db:status         # verify row counts
```

**Timeline note:** seed data is frozen around **2024-12-01** (statement dates, notifications, the "today" of price history). Time-relative API features, such as advisor availability computed from `LocalDate.now(America/Toronto)`, run against the real clock, so seeded appointments are in the past.
