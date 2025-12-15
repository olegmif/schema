-- 8) Удаляем таблицу ссылок (item_references)
DROP INDEX IF EXISTS idx_item_refs_from;
DROP INDEX IF EXISTS idx_item_refs_to;
DROP TABLE IF EXISTS item_references;

-- 7) Удаляем таблицу значений полей для экземпляров коллекций (item_field_values)
DROP INDEX IF EXISTS idx_ifv_item;
DROP INDEX IF EXISTS idx_ifv_field;
DROP INDEX IF EXISTS idx_ifv_value;
DROP TABLE IF EXISTS item_field_values;

-- 6) Удаляем таблицу значений (values)
DROP INDEX IF EXISTS idx_values_int;
DROP INDEX IF EXISTS idx_values_float;
DROP INDEX IF EXISTS idx_values_date;
DROP INDEX IF EXISTS idx_values_dt;
DROP INDEX IF EXISTS idx_values_json_gin;
DROP TABLE IF EXISTS values;

-- 5) Удаляем таблицу экземпляров коллекций (items)
DROP INDEX IF EXISTS idx_items_collection;
DROP TABLE IF EXISTS items;

-- 4) Удаляем таблицу полей внутри схемы (schemas_fields)
DROP INDEX IF EXISTS idx_schemas_fields_schema;
DROP INDEX IF EXISTS idx_schemas_fields_field;
DROP TABLE IF EXISTS schemas_fields;

-- 3) Удаляем таблицу полей (fields)
DROP INDEX IF EXISTS idx_fields_name;
DROP TABLE IF EXISTS fields;

-- 2) Удаляем таблицу коллекций (collections)
DROP INDEX IF EXISTS idx_collections_schema_id;
DROP TABLE IF EXISTS collections;

-- 1) Удаляем таблицу схем (schemas)
DROP TABLE IF EXISTS schemas;

-- 0) Удаляем тип field_type, если он не используется
DROP TYPE IF EXISTS field_type;

