---
slug: security-and-access-control
title: "Security and Access Control"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 12. Security and Access Control

> **This is a demo/workshop database.** The DDL itself says so: `users.password` is "demo only: plain text, never do this for real". Read this section as a description of what exists, not as a production security posture.

### 12.1 Role-Based Access Control (RBAC)

SQLite has **no users, roles, GRANTs or connection authentication**. Access control is the **operating-system file permission** on `data/electric-wealth.db`. Anyone who can read the file can read everything; anyone who can write it can change anything.

| "Role" | Who | Effective permissions |
|------|---------|-----------|
| File owner (developer) | Person running `npm run db:*`, DBeaver, sqlite3 | Full read/write, DDL |
| Spring API process | `electric-wealth-api-spring` (HikariCP, max 4 connections) | Full read/write. By convention DML only; it never issues DDL (`DatabaseConfig.java`). |
| Node API process | A sibling Node API that shares the `sessions` table (referenced in `SessionRepository` Javadoc; not in this workspace) | Full read/write |

**Permission matrix (by convention, not enforced):**

| Actor | Schema (DDL) | Reference data (`advisors`, `securities`, `education_content`, `glossary_terms`, `security_questions`, `baskets`, market news/roundup) | User data | `schema_migrations` |
|---|---|---|---|---|
| `scripts/migrate.js` | ALL | — | — | INSERT |
| `scripts/seed.js` | — | INSERT | INSERT | — |
| Spring API | none | SELECT | SELECT / INSERT / UPDATE / DELETE (see the consumer guide) | — |

### 12.2 Row-Level Security (RLS)

SQLite has **no RLS**. Tenant isolation is enforced entirely by the API: every repository query includes `WHERE user_id = ?`, bound from the authenticated principal (`@AuthenticationPrincipal AuthenticatedUser`). The composite `(user_id, id)` primary keys make "another user's row with the same id" impossible to hit by id alone. This is a structural safeguard, not a security control.

**Application developer impact:** any new query on a tenant table **must** filter by `user_id`. Nothing in the database will stop a cross-tenant read.

### 12.3 Sensitive Data Inventory

| Data | Column(s) | Stored as | Risk |
|---|---|---|---|
| Passwords | `users.password`, `registrations.password` | **Plain text** | Critical outside a demo. Hash with bcrypt or argon2 before any real use. |
| MFA code | `users.mfa_code` | Plain text, fixed per user (`123456` in seed and for new registrations) | Not a real second factor |
| Security answers | `registration_security_answers.answer`, `user_security_answers.answer` | Normalised plain text (lower-case, trimmed) | Should be hashed |
| Bearer tokens | `sessions.access_token`, `sessions.refresh_token` | Plain text (`mock-at-<uuid>` / `mock-rt-<uuid>`) | Readable by anyone with file access; revoked and expired rows are kept indefinitely |
| SIN, phone | `*.sin_masked`, `*.phone_masked` | **Masked at rest**, last digits only (`••• ••• 821`) | Low. Full values are never stored. |
| Date of birth, address, postal code | `users`, `user_profiles`, `offline_clients` | Plain text | PII; used as identity-proofing factors during enrolment |
| Email | `users.email`, `registrations.email`, `document_shares.recipient` | Plain text | PII |

### 12.4 Encryption

- **At rest:** none. Standard SQLite has no encryption; no SEE or SQLCipher is configured.
- **In transit:** not applicable (in-process file access).

### 12.5 File-Level Protections

- `.gitignore` excludes `data/`, `*.db`, `*.db-wal`, `*.db-shm`, `*.db-journal` and `.env`, so the database and any `DB_PATH` override are not committed.
- The seed data is fictional (six personas with `@example.com` addresses).
