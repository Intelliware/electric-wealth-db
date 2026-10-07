-- 004_education.sql
-- Learning centre: the course catalogue, each client's progress, and the glossary.
-- Catalogue and glossary text is stored in English and French; the API picks one
-- from the request's Accept-Language header.

CREATE TABLE education_content (
    id            TEXT    PRIMARY KEY,
    title_en      TEXT    NOT NULL,
    title_fr      TEXT    NOT NULL,
    level         TEXT    NOT NULL CHECK (level IN ('beginner', 'intermediate', 'advanced')),
    type          TEXT    NOT NULL CHECK (type IN ('class', 'challenge')),
    duration_min  INTEGER NOT NULL CHECK (duration_min > 0),
    sort_order    INTEGER NOT NULL DEFAULT 0
);

-- No row = not started (0%).
CREATE TABLE education_progress (
    user_id       TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content_id    TEXT    NOT NULL REFERENCES education_content(id) ON DELETE CASCADE,
    progress_pct  INTEGER NOT NULL CHECK (progress_pct BETWEEN 0 AND 100),
    updated_at    TEXT    NOT NULL,
    PRIMARY KEY (user_id, content_id)
);

CREATE TABLE glossary_terms (
    id             TEXT    PRIMARY KEY,
    term_en        TEXT    NOT NULL,
    term_fr        TEXT    NOT NULL,
    definition_en  TEXT    NOT NULL,
    definition_fr  TEXT    NOT NULL,
    sort_order     INTEGER NOT NULL DEFAULT 0
);
