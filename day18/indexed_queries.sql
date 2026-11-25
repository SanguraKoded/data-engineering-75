
-- DAY 18: QUERY OPTIMIZATION AND INDEXES
-- Database: weather_dw
-- Table: weather_raw
-- Actual city column: name
-- Actual timestamp column: dt (Unix seconds)

-- 1. Inspect the table before optimization
SELECT COUNT(*) AS total_records
FROM weather_raw;

-- 2. Baseline: filter by city
EXPLAIN ANALYZE
SELECT *
FROM weather_raw
WHERE name = 'Kinshasa';

-- 3. Baseline: filter by timestamp range
-- This example uses the last 30 days.
EXPLAIN ANALYZE
SELECT name, temperature, humidity, dt
FROM weather_raw
WHERE dt >= EXTRACT(EPOCH FROM (NOW() - INTERVAL '30 days'))::BIGINT
  AND dt < EXTRACT(EPOCH FROM NOW())::BIGINT;

-- 4. Baseline: filter by city and order by timestamp
EXPLAIN ANALYZE
SELECT name, temperature, humidity, dt
FROM weather_raw
WHERE name = 'Kinshasa'
ORDER BY dt DESC;

-- 5. Create individual indexes
CREATE INDEX idx_weather_name
ON weather_raw (name);

CREATE INDEX idx_weather_dt
ON weather_raw (dt);

-- 6. Repeat the city query after indexing
EXPLAIN ANALYZE
SELECT *
FROM weather_raw
WHERE name = 'Kinshasa';

-- 7. Repeat the timestamp query after indexing
EXPLAIN ANALYZE
SELECT name, temperature, humidity, dt
FROM weather_raw
WHERE dt >= EXTRACT(EPOCH FROM (NOW() - INTERVAL '30 days'))::BIGINT
  AND dt < EXTRACT(EPOCH FROM NOW())::BIGINT;

-- 8. Create a composite index
CREATE INDEX idx_weather_name_dt
ON weather_raw (name, dt);

-- 9. Test a query that can benefit from the composite index
EXPLAIN ANALYZE
SELECT name, temperature, humidity, dt
FROM weather_raw
WHERE name = 'Kinshasa'
ORDER BY dt DESC;

-- 10. Inspect the indexes on the table
SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'weather_raw';

-- 11. Inspect table and index sizes
SELECT
    pg_size_pretty(pg_relation_size('weather_raw')) AS table_size,
    pg_size_pretty(pg_indexes_size('weather_raw')) AS indexes_size,
    pg_size_pretty(pg_total_relation_size('weather_raw')) AS total_size;
