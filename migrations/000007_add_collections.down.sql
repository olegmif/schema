
-- 6) Удаляем таблицу ссылок (item_references)
DROP INDEX IF EXISTS idx_item_refs_from;
DROP INDEX IF EXISTS idx_item_refs_to;
DROP TABLE IF EXISTS item_references;

-- 5) Удаляем таблицу значений полей для экземпляров коллекций (item_field_values)
DROP INDEX IF EXISTS idx_ifv_item;
DROP INDEX IF EXISTS idx_ifv_field;
DROP INDEX IF EXISTS idx_ifv_value;
DROP TABLE IF EXISTS item_field_values;

-- 4) Удаляем таблицу значений (values)
DROP INDEX IF EXISTS idx_values_int;
DROP INDEX IF EXISTS idx_values_float;
DROP INDEX IF EXISTS idx_values_date;
DROP INDEX IF EXISTS idx_values_dt;
DROP INDEX IF EXISTS idx_values_json_gin;
DROP TABLE IF EXISTS values;

-- 3) Удаляем таблицу экземпляров коллекций (items)
DROP INDEX IF EXISTS idx_items_collection;
DROP TABLE IF EXISTS items;

-- 2) Удаляем таблицу полей (fields) + индексы
DROP INDEX IF EXISTS idx_fields_collection_id;
DROP INDEX IF EXISTS idx_fields_name;
DROP INDEX IF EXISTS idx_fields_type;
DROP TABLE IF EXISTS fields;

-- 1) Удаляем таблицу коллекций (collections)
DROP TABLE IF EXISTS collections;

-- 0) Удаляем тип field_type, если он не используется
DROP TYPE IF EXISTS field_type;
