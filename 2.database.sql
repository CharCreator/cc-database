CREATE TABLE IF NOT EXISTS users
(
    id             SERIAL PRIMARY KEY,
    email          VARCHAR(255) NOT NULL,
    password_hash  VARCHAR(60)  NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email_verified BOOLEAN  NOT NULL DEFAULT FALSE,
    blocked        BOOLEAN NOT NULL  DEFAULT FALSE,
    admin_level    INT     NOT NULL  DEFAULT 0,
    last_login     TIMESTAMP,

    UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS sessions
(
    id         SERIAL PRIMARY KEY,
    user_id    INT          NOT NULL,
    token      VARCHAR(256) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS assets
(
    id            SERIAL PRIMARY KEY,
    file_name     uuid       NOT NULL,
    cover         JSONB NOT NULL,
    created_at    TIMESTAMP      NOT NULL     DEFAULT CURRENT_TIMESTAMP,
    modified_at   TIMESTAMP      NOT NULL     DEFAULT CURRENT_TIMESTAMP,
    asset_type    asset_type NOT NULL,
    colorable     BOOLEAN      NOT NULL       DEFAULT FALSE,
    default_properties JSONB NOT NULL ,

    UNIQUE (file_name)
);

CREATE TABLE IF NOT EXISTS codes
(
    id         SERIAL PRIMARY KEY,
    user_id    INT          NOT NULL,
    purpose    code_purpose NOT NULL,
    code       uuid         NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    used_at    TIMESTAMP,
    expires_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,

    UNIQUE (code)
);

CREATE TABLE IF NOT EXISTS used_assets
(
    id         SERIAL PRIMARY KEY,
    user_id    INT NOT NULL,
    asset_id   INT NOT NULL,
    properties JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (asset_id) REFERENCES assets (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS saved_characters
(
    id         SERIAL PRIMARY KEY,
    user_id    INT          NOT NULL,
    name       VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    UNIQUE (user_id, name)
);

CREATE TABLE IF NOT EXISTS saved_character_assets
(
    id                 SERIAL PRIMARY KEY,
    saved_character_id INT NOT NULL,
    used_asset_id      INT NOT NULL,
    created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (saved_character_id) REFERENCES saved_characters (id) ON DELETE CASCADE,
    FOREIGN KEY (used_asset_id) REFERENCES used_assets (id) ON DELETE CASCADE
);