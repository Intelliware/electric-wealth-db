---
slug: data-retention-and-archival
title: "Data Retention and Archival"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 17. Data Retention and Archival

### 17.1 Data Retention Policy

No retention policy, archival job or purge exists in source. Effective retention is "until the next `npm run db:reset`". The table records **behaviour as implemented**:

| Table | Retention (as implemented) | Deletion path | Notes |
|-------|------------------|-------------------|-------|
| `users` and all CASCADE children | Indefinite | No API delete. A manual `DELETE` is blocked by `offline_clients.enrolled_user_id` / `registrations.user_id` (§ 6.3). | No soft delete |
| `sessions` | **Indefinite, unbounded growth** | None. Rows are only `revoked = 1` or past `expires_at`; each refresh adds a row. | Candidate for a purge, e.g. `DELETE FROM sessions WHERE revoked = 1 OR expires_at < strftime('%Y-%m-%dT%H:%M:%fZ','now')` |
| `registrations` (+ answers) | Indefinite | None. Expired (> 30 min) and abandoned rows remain, still holding a **plain-text password**. | Candidate for a purge of `user_id IS NULL AND expires_at < now` |
| `document_shares` | Indefinite (audit) | Cascade from `documents` | Expired links stay as audit records ("recorded so it can be audited") |
| `appointments` | Indefinite | Cancel sets `status='cancelled'`; cascade from `users` | |
| `advisor_messages`, `notifications` | Indefinite | Cascade from `users` | |
| `watchlist` | Until removed | Hard `DELETE` by the API | |
| Reference/catalogue tables | Until the next reset | Seed only | |

### 17.2 Archival Process

None. There are no archive tables, no scheduled jobs and no archive database. If retention rules are introduced, the natural cut points are `sessions.expires_at`, `registrations.expires_at` and `document_shares.expires_at`, all ISO-8601 UTC TEXT and comparable as strings. Comparing against a millisecond-precision now (`…%fZ`) works for both the second-precision and millisecond-precision values used here, accurate to within one second: within the same second `'…21Z'` sorts after `'…21.917Z'`.

---

# Part 7 — Operational
