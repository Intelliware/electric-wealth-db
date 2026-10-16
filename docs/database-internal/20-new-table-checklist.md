---
slug: new-table-checklist
title: "New Table Checklist"
part: A
source-commit: 05ff1a61e87f62666c0fceb35fc1604c1d7abccd
---

## 26. New Table Checklist

When adding a table to this database, follow the conventions already in use:

- [ ] **Migration file:** new `migrations/NNN_<description>.sql` (next number, zero-padded), starting with a 1–3 line comment header describing what and why.
- [ ] **Table name:** lowercase, plural, `snake_case` (§ 4.1).
- [ ] **Primary key:** for user-owned data, `user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE` plus `id TEXT NOT NULL`, with `PRIMARY KEY (user_id, id)`. For global entities, `id TEXT PRIMARY KEY` (the API generates `<prefix>-<8 hex>`). Avoid INTEGER AUTOINCREMENT unless it is an append-only audit table (precedent: `document_shares`).
- [ ] **Foreign keys:** declare `ON DELETE` explicitly. Use CASCADE for user-owned children, and leave NO ACTION only for references to protected reference data. Do **not** add a NO ACTION FK to `users`: it blocks user deletion (§ 6.3).
- [ ] **Money:** `INTEGER` minor units plus a `currency TEXT NOT NULL` column.
- [ ] **Booleans:** `INTEGER NOT NULL DEFAULT 0 CHECK (col IN (0, 1))`. Name them as a bare adjective (`hidden`, `read`).
- [ ] **Enumerations:** `TEXT NOT NULL CHECK (col IN (...))`, mirrored by a Java enum in the API (`dto/ApiEnums.java`).
- [ ] **Timestamps:** `TEXT` ISO-8601 UTC, `<verb>_at` naming. Consider `DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))` for `created_at`.
- [ ] **Localised text:** paired `_en` / `_fr` columns, both `NOT NULL`.
- [ ] **Ordering:** `sort_order INTEGER NOT NULL DEFAULT 0` if the list is user-visible.
- [ ] **Indexes:** the composite PK covers `WHERE user_id = ?`. Add `ix_<table>_<purpose>` only when sorting on a non-PK column, or when an FK child column would otherwise be scanned on parent delete.
- [ ] **Soft delete / updated_at:** not used in this schema. Do not add them unless there is a requirement; there are no triggers to maintain `updated_at`.
- [ ] **Seed data:** add `seed/1NN_<feature>.sql` (where `NN` = the migration number). If it needs persona data, rely on the persona files having run first.
- [ ] **API:** add a repository in `electric-wealth-api-spring` and keep every query tenant-scoped (`WHERE user_id = ?`).
- [ ] **Reset & verify:** `npm run db:reset && npm run db:status`. Then `sqlite3 data/electric-wealth.db "PRAGMA foreign_key_check;"`.
- [ ] **Data retention:** state in the migration header whether rows ever expire (§ 17).
- [ ] **Documentation:** update this Part A (§ 5 tables, § 6 FK list, § 7 indexes, § 3 ERD) and the KB data dictionary and `erd.mmd`, and log the change in `CHANGE-TRACKER.md`.
