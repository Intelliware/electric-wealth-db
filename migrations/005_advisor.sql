-- 005_advisor.sql
-- Advisors, which advisor each client has, booked meetings, and secure messages.

CREATE TABLE advisors (
    id           TEXT    PRIMARY KEY,
    name         TEXT    NOT NULL,
    designation  TEXT,                    -- e.g. CFP
    available    INTEGER NOT NULL DEFAULT 1 CHECK (available IN (0, 1))
);

-- NULL = no advisor assigned yet.
ALTER TABLE users ADD COLUMN advisor_id TEXT REFERENCES advisors(id);

-- date is a calendar date and time a 24h 'HH:MM' start, both in Toronto time.
CREATE TABLE appointments (
    id            TEXT    PRIMARY KEY,
    user_id       TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    advisor_id    TEXT    NOT NULL REFERENCES advisors(id),
    meeting_type  TEXT    NOT NULL CHECK (meeting_type IN ('video', 'phone', 'in_person')),
    date          TEXT    NOT NULL,
    time          TEXT    NOT NULL,
    status        TEXT    NOT NULL DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    notes         TEXT,
    created_at    TEXT    NOT NULL
);

CREATE INDEX ix_appointments_user ON appointments(user_id, date, time);

-- An advisor can only have one scheduled meeting per slot.
CREATE UNIQUE INDEX ux_appointments_advisor_slot ON appointments(advisor_id, date, time) WHERE status = 'scheduled';

CREATE TABLE advisor_messages (
    id          TEXT    PRIMARY KEY,
    user_id     TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    advisor_id  TEXT    NOT NULL REFERENCES advisors(id),
    sender      TEXT    NOT NULL CHECK (sender IN ('advisor', 'client')),
    text        TEXT    NOT NULL,
    sent_at     TEXT    NOT NULL
);

CREATE INDEX ix_advisor_messages_user ON advisor_messages(user_id, sent_at);
