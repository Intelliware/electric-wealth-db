-- 003_document_shares.sql
-- Secure links to a document sent to someone outside the app (e.g. an accountant).
-- Each share is recorded so it can be audited; links expire after expires_at.

CREATE TABLE document_shares (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id      TEXT    NOT NULL,
    document_id  TEXT    NOT NULL,
    recipient    TEXT    NOT NULL,
    created_at   TEXT    NOT NULL,
    expires_at   TEXT    NOT NULL,
    FOREIGN KEY (user_id, document_id) REFERENCES documents(user_id, id) ON DELETE CASCADE
);

CREATE INDEX ix_document_shares_document ON document_shares(user_id, document_id);
