
-- 0) Тип поля
DO $$ BEGIN
  CREATE TYPE field_type AS ENUM (
    'text',
    'textarea',
    'int',
    'float',
    'bool',
    'date',
    'datetime',
    'json',
    'reference'
  );
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;

-- 1) Коллекции
CREATE TABLE IF NOT EXISTS collections (
  id          bigserial PRIMARY KEY,
  name        text NOT NULL UNIQUE,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- 2) Поля (принадлежат коллекции, 1:N)
CREATE TABLE IF NOT EXISTS fields (
  id            bigserial PRIMARY KEY,
  collection_id bigint NOT NULL REFERENCES collections(id) ON DELETE CASCADE,

  name          text NOT NULL,
  type          field_type NOT NULL,

  required      boolean NOT NULL DEFAULT false,
  sort_order    int     NOT NULL DEFAULT 0,
  is_unique     boolean NOT NULL DEFAULT false,

  created_at    timestamptz NOT NULL DEFAULT now(),

  -- имя поля уникально внутри коллекции
  UNIQUE (collection_id, name)
);

CREATE INDEX IF NOT EXISTS idx_fields_collection_id ON fields(collection_id);
CREATE INDEX IF NOT EXISTS idx_fields_name          ON fields(name);
CREATE INDEX IF NOT EXISTS idx_fields_type          ON fields(type);

-- 3) Экземпляры коллекции (items)
CREATE TABLE IF NOT EXISTS items (
  id            bigserial PRIMARY KEY,
  collection_id bigint NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_items_collection ON items(collection_id);

-- 4) Значения (одно значение = один тип)
CREATE TABLE IF NOT EXISTS values (
  id             bigserial PRIMARY KEY,

  text_value     text,
  int_value      bigint,
  float_value    double precision,
  bool_value     boolean,
  date_value     date,
  datetime_value timestamptz,
  json_value     jsonb,

  created_at     timestamptz NOT NULL DEFAULT now(),

  CHECK (
    (text_value      IS NOT NULL)::int +
    (int_value       IS NOT NULL)::int +
    (float_value     IS NOT NULL)::int +
    (bool_value      IS NOT NULL)::int +
    (date_value      IS NOT NULL)::int +
    (datetime_value  IS NOT NULL)::int +
    (json_value      IS NOT NULL)::int
    = 1
  )
);

CREATE INDEX IF NOT EXISTS idx_values_int      ON values(int_value)      WHERE int_value IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_values_float    ON values(float_value)    WHERE float_value IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_values_date     ON values(date_value)     WHERE date_value IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_values_dt       ON values(datetime_value) WHERE datetime_value IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_values_json_gin ON values USING gin (json_value) WHERE json_value IS NOT NULL;

-- 5) item + field -> value (главный слой)
CREATE TABLE IF NOT EXISTS item_field_values (
  item_id    bigint NOT NULL REFERENCES items(id)  ON DELETE CASCADE,
  field_id   bigint NOT NULL REFERENCES fields(id) ON DELETE RESTRICT,
  value_id   bigint NOT NULL REFERENCES values(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),

  PRIMARY KEY (item_id, field_id)
);

CREATE INDEX IF NOT EXISTS idx_ifv_item  ON item_field_values(item_id);
CREATE INDEX IF NOT EXISTS idx_ifv_field ON item_field_values(field_id);
CREATE INDEX IF NOT EXISTS idx_ifv_value ON item_field_values(value_id);

-- 6) Reference-поля: from_item --(field)--> to_item
CREATE TABLE IF NOT EXISTS item_references (
  from_item_id bigint NOT NULL REFERENCES items(id)  ON DELETE CASCADE,
  field_id     bigint NOT NULL REFERENCES fields(id) ON DELETE RESTRICT,
  to_item_id   bigint NOT NULL REFERENCES items(id)  ON DELETE CASCADE,

  PRIMARY KEY (from_item_id, field_id, to_item_id)
);

CREATE INDEX IF NOT EXISTS idx_item_refs_from ON item_references(from_item_id);
CREATE INDEX IF NOT EXISTS idx_item_refs_to   ON item_references(to_item_id);
