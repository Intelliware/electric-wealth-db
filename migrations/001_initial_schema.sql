-- 001_initial_schema.sql
-- Core schema for the Electric Wealth web edition.
--
-- Conventions
--   * Money is stored in minor units (cents) as INTEGER, alongside an ISO-4217 currency code.
--   * Booleans are INTEGER 0/1.
--   * Dates/times are ISO-8601 TEXT (UTC), e.g. '2024-12-01T14:30:00Z'.
--   * Business ids (account 'tfsa', document 'd1', ...) are only unique per user,
--     so most tables use a composite primary key that starts with user_id.

-- ---------------------------------------------------------------------------
-- Users & identity
-- ---------------------------------------------------------------------------

CREATE TABLE users (
    id              TEXT    PRIMARY KEY,
    email           TEXT    NOT NULL UNIQUE COLLATE NOCASE,
    password        TEXT    NOT NULL,          -- demo only: plain text, never do this for real
    mfa_code        TEXT    NOT NULL,          -- demo only: fixed one-time code
    name            TEXT    NOT NULL,
    account_number  TEXT    NOT NULL,
    date_of_birth   TEXT    NOT NULL,
    created_at      TEXT    NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);

CREATE TABLE user_profiles (
    user_id                       TEXT    PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    phone_masked                  TEXT    NOT NULL,
    sin_masked                    TEXT,
    member_since                  INTEGER NOT NULL,
    address_line1                 TEXT    NOT NULL,
    address_line2                 TEXT,
    city                          TEXT    NOT NULL,
    province                      TEXT    NOT NULL,
    postal_code                   TEXT    NOT NULL,
    country                       TEXT    NOT NULL,
    trusted_contact_name          TEXT,
    trusted_contact_relationship  TEXT
);

CREATE TABLE user_preferences (
    user_id               TEXT    PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    notify_email          INTEGER NOT NULL CHECK (notify_email IN (0, 1)),
    notify_sms            INTEGER NOT NULL CHECK (notify_sms IN (0, 1)),
    notify_push           INTEGER NOT NULL CHECK (notify_push IN (0, 1)),
    document_delivery     TEXT    NOT NULL CHECK (document_delivery IN ('digital', 'paper_and_digital')),
    language              TEXT    NOT NULL CHECK (language IN ('en-CA', 'fr-CA')),
    theme                 TEXT    NOT NULL CHECK (theme IN ('light', 'dark', 'system')),
    default_meeting_type  TEXT    NOT NULL CHECK (default_meeting_type IN ('video', 'phone', 'in_person'))
);

-- Access/refresh token sessions issued by the API.
CREATE TABLE sessions (
    access_token   TEXT    PRIMARY KEY,
    refresh_token  TEXT    NOT NULL UNIQUE,
    user_id        TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    mfa_verified   INTEGER NOT NULL DEFAULT 0 CHECK (mfa_verified IN (0, 1)),
    revoked        INTEGER NOT NULL DEFAULT 0 CHECK (revoked IN (0, 1)),
    expires_at     TEXT    NOT NULL,
    created_at     TEXT    NOT NULL
);

CREATE INDEX ix_sessions_user ON sessions(user_id);

-- ---------------------------------------------------------------------------
-- Accounts, holdings, transactions, performance
-- ---------------------------------------------------------------------------

CREATE TABLE accounts (
    user_id            TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id                 TEXT    NOT NULL,
    type               TEXT    NOT NULL CHECK (type IN ('TFSA', 'RRSP', 'RESP', 'RDSP', 'FHSA', 'NON_REGISTERED', 'LIRA', 'RRIF')),
    display_name       TEXT    NOT NULL,
    nickname           TEXT,
    balance            INTEGER NOT NULL,
    currency           TEXT    NOT NULL,
    hidden             INTEGER NOT NULL DEFAULT 0 CHECK (hidden IN (0, 1)),
    day_change         INTEGER,
    day_change_pct     REAL,
    contribution_room  INTEGER,
    tax_status         TEXT    NOT NULL,
    rate_of_return     REAL,
    sort_order         INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, id)
);

CREATE TABLE holdings (
    user_id       TEXT    NOT NULL,
    account_id    TEXT    NOT NULL,
    symbol        TEXT    NOT NULL,
    name          TEXT    NOT NULL,
    quantity      REAL    NOT NULL,
    market_value  INTEGER NOT NULL,
    currency      TEXT    NOT NULL,
    weight_pct    REAL    NOT NULL,
    PRIMARY KEY (user_id, account_id, symbol),
    FOREIGN KEY (user_id, account_id) REFERENCES accounts(user_id, id) ON DELETE CASCADE
);

-- status 'posted' = settled history, 'scheduled' = upcoming (e.g. auto-contributions).
CREATE TABLE transactions (
    user_id      TEXT    NOT NULL,
    account_id   TEXT    NOT NULL,
    id           TEXT    NOT NULL,
    date         TEXT    NOT NULL,
    description  TEXT    NOT NULL,
    detail       TEXT,
    type         TEXT    NOT NULL CHECK (type IN ('contribution', 'buy', 'sell', 'dividend', 'fee', 'withdrawal', 'transfer', 'scheduled')),
    amount       INTEGER NOT NULL,
    currency     TEXT    NOT NULL,
    status       TEXT    NOT NULL DEFAULT 'posted' CHECK (status IN ('posted', 'scheduled')),
    PRIMARY KEY (user_id, account_id, id),
    FOREIGN KEY (user_id, account_id) REFERENCES accounts(user_id, id) ON DELETE CASCADE
);

CREATE INDEX ix_transactions_account_date ON transactions(user_id, account_id, date DESC);

CREATE TABLE account_performance (
    user_id                   TEXT    NOT NULL,
    account_id                TEXT    NOT NULL,
    time_weighted_return_pct  REAL    NOT NULL,
    currency                  TEXT    NOT NULL,
    benchmark_name            TEXT    NOT NULL,
    PRIMARY KEY (user_id, account_id),
    FOREIGN KEY (user_id, account_id) REFERENCES accounts(user_id, id) ON DELETE CASCADE
);

-- series 'account' values are minor units; series 'benchmark' values are an index (start = 100).
CREATE TABLE performance_points (
    user_id     TEXT    NOT NULL,
    account_id  TEXT    NOT NULL,
    series      TEXT    NOT NULL CHECK (series IN ('account', 'benchmark')),
    period      TEXT    NOT NULL,          -- e.g. '2024-03'
    value       REAL    NOT NULL,
    PRIMARY KEY (user_id, account_id, series, period),
    FOREIGN KEY (user_id, account_id) REFERENCES accounts(user_id, id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- Documents
-- ---------------------------------------------------------------------------

CREATE TABLE documents (
    user_id          TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id               TEXT    NOT NULL,
    name             TEXT    NOT NULL,
    category         TEXT    NOT NULL,
    year             INTEGER NOT NULL,
    account_id       TEXT,                 -- NULL = applies to all accounts
    account_label    TEXT,
    size_bytes       INTEGER NOT NULL,
    action_required  INTEGER NOT NULL DEFAULT 0 CHECK (action_required IN (0, 1)),
    url              TEXT    NOT NULL,
    PRIMARY KEY (user_id, id)
);

-- ---------------------------------------------------------------------------
-- Goals & dashboard content
-- ---------------------------------------------------------------------------

CREATE TABLE goals (
    user_id            TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id                 TEXT    NOT NULL,
    name               TEXT    NOT NULL,
    category           TEXT    NOT NULL CHECK (category IN ('Education', 'Vacation', 'Home', 'Retirement', 'Safety')),
    current_amount     INTEGER NOT NULL,
    target_amount      INTEGER NOT NULL,
    currency           TEXT    NOT NULL,
    target_date        TEXT    NOT NULL,
    progress_pct       REAL    NOT NULL,
    show_on_dashboard  INTEGER NOT NULL DEFAULT 0 CHECK (show_on_dashboard IN (0, 1)),
    sort_order         INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, id)
);

-- Portfolio-level figures that are not derived from account balances.
-- (Total value is computed by the API from visible account balances.)
CREATE TABLE portfolio_snapshots (
    user_id         TEXT    PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    currency        TEXT    NOT NULL,
    day_change      INTEGER NOT NULL,
    day_change_pct  REAL    NOT NULL,
    as_of           TEXT    NOT NULL
);

CREATE TABLE asset_allocations (
    user_id      TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    asset_class  TEXT    NOT NULL,
    pct          REAL    NOT NULL,
    sort_order   INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id, asset_class)
);

CREATE TABLE alerts (
    user_id    TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    id         TEXT    NOT NULL,
    type       TEXT    NOT NULL CHECK (type IN ('ACTION_REQUIRED', 'INFO', 'SUCCESS', 'WARNING')),
    title      TEXT    NOT NULL,
    deep_link  TEXT,
    PRIMARY KEY (user_id, id)
);

CREATE TABLE quick_links (
    user_id     TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sort_order  INTEGER NOT NULL,
    label       TEXT    NOT NULL,
    deep_link   TEXT    NOT NULL,
    PRIMARY KEY (user_id, sort_order)
);
