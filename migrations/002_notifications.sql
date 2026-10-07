-- 002_notifications.sql
-- In-app notifications shown in the notification centre.

CREATE TABLE notifications (
    user_id     TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id          TEXT    NOT NULL,
    title       TEXT    NOT NULL,
    body        TEXT    NOT NULL,
    type        TEXT    NOT NULL CHECK (type IN ('ACTION_REQUIRED', 'INFO', 'SUCCESS', 'WARNING')),
    created_at  TEXT    NOT NULL,
    read        INTEGER NOT NULL DEFAULT 0 CHECK (read IN (0, 1)),
    PRIMARY KEY (user_id, id)
);

CREATE INDEX ix_notifications_user_created ON notifications(user_id, created_at DESC);
