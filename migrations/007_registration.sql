-- 007_registration.sql
-- Online enrolment for existing clients. A client opened by a branch or advisor exists in
-- offline_clients; they prove who they are (account number, postal code, date of birth),
-- choose a login, and on completion become a regular row in users.

CREATE TABLE offline_clients (
    account_number      TEXT    PRIMARY KEY,
    name                TEXT    NOT NULL,
    date_of_birth       TEXT    NOT NULL,
    phone_masked        TEXT    NOT NULL,
    sin_masked          TEXT,
    client_since        INTEGER NOT NULL,       -- year
    address_line1       TEXT    NOT NULL,
    address_line2       TEXT,
    city                TEXT    NOT NULL,
    province            TEXT    NOT NULL,
    postal_code         TEXT    NOT NULL,       -- stored as 'A1A 1A1'
    country             TEXT    NOT NULL,
    language            TEXT    NOT NULL CHECK (language IN ('en-CA', 'fr-CA')),
    advisor_id          TEXT    REFERENCES advisors(id),
    enrolled_user_id    TEXT    REFERENCES users(id)   -- set once they have registered online
);

CREATE TABLE security_questions (
    id        TEXT    PRIMARY KEY,
    text_en   TEXT    NOT NULL,
    text_fr   TEXT    NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0
);

-- One in-progress (or finished) registration. Steps fill in columns in order.
CREATE TABLE registrations (
    id                         TEXT    PRIMARY KEY,
    email                      TEXT    NOT NULL COLLATE NOCASE,
    password                   TEXT    NOT NULL,     -- demo only: plain text, like users.password
    account_number             TEXT    REFERENCES offline_clients(account_number),  -- set when identity is verified
    trusted_contact_name           TEXT,
    trusted_contact_relationship   TEXT,
    trusted_contact_phone          TEXT,
    trusted_contact_email          TEXT,
    security_answers_saved     INTEGER NOT NULL DEFAULT 0 CHECK (security_answers_saved IN (0, 1)),
    mfa_method                 TEXT    CHECK (mfa_method IN ('sms', 'email')),
    consented_at               TEXT,
    user_id                    TEXT    REFERENCES users(id),   -- set when completed
    created_at                 TEXT    NOT NULL,
    expires_at                 TEXT    NOT NULL
);

-- Answers are kept normalised (trimmed, lower case) so they can be compared later.
CREATE TABLE registration_security_answers (
    registration_id  TEXT    NOT NULL REFERENCES registrations(id) ON DELETE CASCADE,
    question_id      TEXT    NOT NULL REFERENCES security_questions(id),
    answer           TEXT    NOT NULL,
    PRIMARY KEY (registration_id, question_id)
);

CREATE TABLE user_security_answers (
    user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    question_id  TEXT    NOT NULL REFERENCES security_questions(id),
    answer       TEXT    NOT NULL,
    PRIMARY KEY (user_id, question_id)
);

-- How the client wants to receive one-time codes, and when they accepted the terms.
ALTER TABLE users ADD COLUMN mfa_method TEXT NOT NULL DEFAULT 'sms' CHECK (mfa_method IN ('sms', 'email'));
ALTER TABLE users ADD COLUMN terms_accepted_at TEXT;
