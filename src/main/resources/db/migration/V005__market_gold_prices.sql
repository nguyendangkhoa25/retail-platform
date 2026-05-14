-- Market gold price cache — one row per (ktype, source), upserted every poll cycle
CREATE TABLE IF NOT EXISTS market_gold_prices (
    ktype       VARCHAR(30)   NOT NULL,
    source      VARCHAR(20)   NOT NULL,
    name        VARCHAR(150)  NOT NULL,
    buy_price   NUMERIC(20,0),
    sell_price  NUMERIC(20,0),
    fetched_at  TIMESTAMP     NOT NULL,
    PRIMARY KEY (ktype, source)
);

-- Full history — appended on every poll, pruned weekly (90-day retention)
CREATE TABLE IF NOT EXISTS market_gold_price_history (
    id          BIGSERIAL     PRIMARY KEY,
    ktype       VARCHAR(30)   NOT NULL,
    source      VARCHAR(20)   NOT NULL,
    name        VARCHAR(150)  NOT NULL,
    buy_price   NUMERIC(20,0),
    sell_price  NUMERIC(20,0),
    fetched_at  TIMESTAMP     NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_mgph_source_ktype_fetched
    ON market_gold_price_history (source, ktype, fetched_at DESC);

CREATE INDEX IF NOT EXISTS idx_mgph_fetched_at
    ON market_gold_price_history (fetched_at DESC);
