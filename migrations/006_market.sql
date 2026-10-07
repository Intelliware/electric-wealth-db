-- 006_market.sql
-- Market data shown in the app (static demo data, not a live feed), plus each client's watchlist.
-- Prices are in minor units (cents) of the security's currency.

CREATE TABLE securities (
    symbol      TEXT    PRIMARY KEY,           -- e.g. 'XEQT.TO' (TSX) or 'AAPL'
    name        TEXT    NOT NULL,
    exchange    TEXT    NOT NULL,
    currency    TEXT    NOT NULL,
    price       INTEGER NOT NULL,              -- last price
    change      INTEGER NOT NULL,              -- change since previous close
    change_pct  REAL    NOT NULL,
    about       TEXT
);

-- t is 'HH:MM' for 1D, 'YYYY-MM-DD' for 1M, 'YYYY-MM' for 1Y and 5Y. Values are closing prices.
CREATE TABLE price_history (
    symbol  TEXT    NOT NULL REFERENCES securities(symbol) ON DELETE CASCADE,
    range   TEXT    NOT NULL CHECK (range IN ('1D', '1M', '1Y', '5Y')),
    t       TEXT    NOT NULL,
    close   INTEGER NOT NULL,
    PRIMARY KEY (symbol, range, t)
);

CREATE TABLE watchlist (
    user_id   TEXT    NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    symbol    TEXT    NOT NULL REFERENCES securities(symbol) ON DELETE CASCADE,
    added_at  TEXT    NOT NULL,
    PRIMARY KEY (user_id, symbol)
);

CREATE TABLE market_news (
    id            TEXT    PRIMARY KEY,
    title         TEXT    NOT NULL,
    source        TEXT    NOT NULL,
    published_at  TEXT    NOT NULL,
    tag           TEXT
);

CREATE TABLE market_roundup_items (
    id            TEXT    PRIMARY KEY,
    week_of       TEXT    NOT NULL,           -- the Monday-or-Sunday date the roundup covers
    title         TEXT    NOT NULL,
    summary       TEXT    NOT NULL,
    published_at  TEXT    NOT NULL
);

-- Thematic baskets: ready-made groups of securities around a theme.
CREATE TABLE baskets (
    id               TEXT    PRIMARY KEY,
    name             TEXT    NOT NULL,
    description      TEXT    NOT NULL,
    return_1y_pct    REAL    NOT NULL,
    holdings_count   INTEGER NOT NULL,
    risk             TEXT    NOT NULL CHECK (risk IN ('Low', 'Medium', 'High')),
    sort_order       INTEGER NOT NULL DEFAULT 0
);
