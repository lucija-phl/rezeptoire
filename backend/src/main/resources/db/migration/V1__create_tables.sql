CREATE TABLE app_user (
    id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username   TEXT NOT NULL UNIQUE,
    email      TEXT NOT NULL UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE recipe (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(id),
    name TEXT NOT NULL,
    subtitle TEXT,
    servings_amount INT,
    servings_unit TEXT DEFAULT 'Portionen',
    duration TEXT CHECK (duration IN ('VERY_QUICK', 'QUICK', 'MEDIUM', 'LONG', 'VERY_LONG')),
    photo_path TEXT,
    is_complete BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ingredient (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE recipe_component (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    recipe_id BIGINT NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
    position INT NOT NULL
);

CREATE TABLE recipe_ingredient (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recipe_id BIGINT NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
    ingredient_id BIGINT NOT NULL REFERENCES ingredient(id),
    component_id BIGINT REFERENCES recipe_component(id) ON DELETE SET NULL,
    position INT NOT NULL,
    amount NUMERIC,
    unit TEXT
);

CREATE TABLE preparation_step(
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recipe_id BIGINT NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
    component_id BIGINT REFERENCES recipe_component(id) ON DELETE SET NULL,
    position INT NOT NULL,
    instruction TEXT NOT NULL
);

CREATE TABLE category (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES app_user(id),
    name TEXT NOT NULL,
    UNIQUE (user_id, name)
);

CREATE TABLE recipe_category (
    recipe_id BIGINT NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
    category_id BIGINT NOT NULL REFERENCES category(id) ON DELETE CASCADE,
    PRIMARY KEY (recipe_id, category_id)
);

CREATE TABLE cooking_entry (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    recipe_id BIGINT NOT NULL REFERENCES recipe(id) ON DELETE CASCADE,
    cooked_on DATE NOT NULL DEFAULT CURRENT_DATE,
    occasion TEXT
);