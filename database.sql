DROP TABLE IF EXISTS users;
CREATE TABLE IF NOT EXISTS users
(
    id              SERIAL           PRIMARY KEY,
    email           VARCHAR(255)     NOT NULL,
    password_hash   VARCHAR(60)      NOT NULL,
    created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    email_verified  BOOLEAN          DEFAULT FALSE,
    blocked         BOOLEAN          DEFAULT FALSE,
    admin_level     INT              DEFAULT 0,
    last_login      TIMESTAMP,

    UNIQUE (email)
);

DROP TABLE IF EXISTS sessions;
CREATE TABLE IF NOT EXISTS sessions
(
    id              SERIAL           PRIMARY KEY,
    user_id         INT              NOT NULL,
    token           VARCHAR(256)     NOT NULL,
    created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    last_used       TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    expires_at      TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS assets;
CREATE TABLE IF NOT EXISTS assets
(
    id              SERIAL           PRIMARY KEY,
    file_name       uuid             NOT NULL,
    created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    asset_type      asset_type       NOT NULL,
    colorable       BOOLEAN          DEFAULT FALSE,
    default_color   VARCHAR(7)       NOT NULL DEFAULT '#000000',

    UNIQUE (file_name)
);

DROP TABLE IF EXISTS codes;
CREATE TABLE IF NOT EXISTS codes
(
    id              SERIAL           PRIMARY KEY,
    user_id         INT              NOT NULL,
    purpose         code_purpose     NOT NULL,
    code            uuid             NOT NULL,
    created_at      TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    used_at         TIMESTAMP,
    expires_at      TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,

    UNIQUE (code)
);

DROP TABLE IF EXISTS used_assets;
CREATE TABLE IF NOT EXISTS used_assets
(
    id              SERIAL          PRIMARY KEY,
    user_id         INT             NOT NULL,
    asset_id        INT             NOT NULL,
    properties      JSONB,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES assets (id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS saved_characters;
CREATE TABLE IF NOT EXISTS saved_characters
(
    id              SERIAL          PRIMARY KEY,
    user_id         INT             NOT NULL,
    name            VARCHAR(255)    NOT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    UNIQUE (user_id, name)
);

DROP TABLE IF EXISTS saved_character_assets;
CREATE TABLE IF NOT EXISTS saved_character_assets
(
    id                 SERIAL       PRIMARY KEY,
    saved_character_id INT          NOT NULL,
    used_asset_id      INT          NOT NULL,
    created_at         TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (saved_character_id) REFERENCES saved_characters (id) ON DELETE CASCADE,
    FOREIGN KEY (used_asset_id) REFERENCES used_assets (id) ON DELETE CASCADE
);