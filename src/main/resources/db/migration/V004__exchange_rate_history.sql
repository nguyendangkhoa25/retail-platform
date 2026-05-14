CREATE TABLE IF NOT EXISTS exchange_rate_history (
    id          BIGSERIAL PRIMARY KEY,
    currency_code VARCHAR(3)    NOT NULL,
    source        VARCHAR(50)   NOT NULL,
    buy_rate      NUMERIC(18,4),
    transfer_rate NUMERIC(18,4),
    sell_rate     NUMERIC(18,4),
    fetched_at    TIMESTAMP     NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_erh_currency_fetched
    ON exchange_rate_history (currency_code, fetched_at DESC);

CREATE INDEX IF NOT EXISTS idx_erh_fetched_at
    ON exchange_rate_history (fetched_at DESC);
