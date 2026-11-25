
-- DAY 17: 15 ANALYTICAL SQL QUERIES
-- Dataset: weather_raw
-- Temperature is stored in Kelvin.
-- Convert to Celsius using temperature - 273.15.


-- Q1. TOTAL WEATHER RECORDS
-- How many weather observations are stored?

SELECT COUNT(*) AS total_records
FROM weather_raw;


-- Q2. RECORDS PER CITY
-- How many observations have been collected for each city?

SELECT
    name AS city,
    COUNT(*) AS total_records
FROM weather_raw
GROUP BY name
ORDER BY total_records DESC;


-- Q3. AVERAGE TEMPERATURE PER CITY
-- Calculate average temperature in Celsius for each city.

SELECT
    name AS city,
    ROUND(AVG(temperature - 273.15)::NUMERIC, 2)
        AS average_temperature_celsius
FROM weather_raw
GROUP BY name
ORDER BY average_temperature_celsius DESC;


-- Q4. HOTTEST DAY EVER
-- Find the date with the highest recorded daily temperature.
-- If there are multiple cities, show the hottest city too.

WITH daily_temperatures AS (
    SELECT
        name AS city,
        TO_TIMESTAMP(dt)::DATE AS reading_date,
        MAX(temperature - 273.15) AS max_temp_celsius
    FROM weather_raw
    GROUP BY name, TO_TIMESTAMP(dt)::DATE
)
SELECT
    city,
    reading_date,
    ROUND(max_temp_celsius::NUMERIC, 2) AS hottest_temperature_celsius
FROM daily_temperatures
ORDER BY max_temp_celsius DESC
LIMIT 1;


-- Q5. COLDEST DAY EVER
-- Find the date with the lowest recorded daily temperature.

WITH daily_temperatures AS (
    SELECT
        name AS city,
        TO_TIMESTAMP(dt)::DATE AS reading_date,
        MIN(temperature - 273.15) AS min_temp_celsius
    FROM weather_raw
    GROUP BY name, TO_TIMESTAMP(dt)::DATE
)
SELECT
    city,
    reading_date,
    ROUND(min_temp_celsius::NUMERIC, 2) AS coldest_temperature_celsius
FROM daily_temperatures
ORDER BY min_temp_celsius ASC
LIMIT 1;


-- Q6. MOST HUMID CITY
-- Find the city with the highest average humidity.

SELECT
    name AS city,
    ROUND(AVG(humidity), 2) AS average_humidity
FROM weather_raw
GROUP BY name
ORDER BY average_humidity DESC
LIMIT 1;


-- Q7. CITIES ABOVE 30 DEGREES MORE THAN 5 TIMES
-- 30°C is equivalent to 303.15 Kelvin.
-- Only return cities with more than five qualifying readings.

SELECT
    name AS city,
    COUNT(*) AS readings_above_30c
FROM weather_raw
WHERE temperature > 303.15
GROUP BY name
HAVING COUNT(*) > 5
ORDER BY readings_above_30c DESC;


-- Q8. TEMPERATURE TREND OVER TIME
-- Display each city's readings chronologically.

SELECT
    name AS city,
    TO_TIMESTAMP(dt) AS reading_time,
    ROUND((temperature - 273.15)::NUMERIC, 2)
        AS temperature_celsius
FROM weather_raw
ORDER BY name, dt;


-- Q9. RANK CITIES BY AVERAGE TEMPERATURE
-- Rank cities from hottest to coldest using RANK().

SELECT
    name AS city,
    ROUND(AVG(temperature - 273.15)::NUMERIC, 2)
        AS average_temperature_celsius,
    RANK() OVER (
        ORDER BY AVG(temperature) DESC
    ) AS temperature_rank
FROM weather_raw
GROUP BY name;


-- Q10. RUNNING AVERAGE TEMPERATURE
-- Calculate the cumulative average temperature for each city.

SELECT
    name AS city,
    TO_TIMESTAMP(dt) AS reading_time,
    ROUND(
        AVG(temperature - 273.15) OVER (
            PARTITION BY name
            ORDER BY dt
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )::NUMERIC,
        2
    ) AS running_average_celsius
FROM weather_raw
ORDER BY name, dt;


-- Q11. DAY-OVER-DAY TEMPERATURE CHANGE
-- Compare each day's average temperature with the previous day.
-- LAG() retrieves the previous day's temperature.

WITH daily_temperatures AS (
    SELECT
        name AS city,
        TO_TIMESTAMP(dt)::DATE AS reading_date,
        AVG(temperature - 273.15) AS average_temp
    FROM weather_raw
    GROUP BY name, TO_TIMESTAMP(dt)::DATE
),
previous_day AS (
    SELECT
        city,
        reading_date,
        average_temp,
        LAG(average_temp) OVER (
            PARTITION BY city
            ORDER BY reading_date
        ) AS previous_day_temp
    FROM daily_temperatures
)
SELECT
    city,
    reading_date,
    ROUND(average_temp::NUMERIC, 2) AS current_temp_celsius,
    ROUND(previous_day_temp::NUMERIC, 2) AS previous_temp_celsius,
    ROUND((average_temp - previous_day_temp)::NUMERIC, 2)
        AS temperature_change
FROM previous_day
ORDER BY city, reading_date;


-- Q12. TEMPERATURE VS HUMIDITY CORRELATION
-- Pearson correlation ranges from -1 to +1.
-- Uses all available observations.

SELECT
    ROUND(
        CORR(temperature - 273.15, humidity)::NUMERIC,
        4
    ) AS temperature_humidity_correlation
FROM weather_raw
WHERE temperature IS NOT NULL
  AND humidity IS NOT NULL;


-- Q13. TOP 3 HOTTEST CITIES PER MONTH
-- Rank cities by average monthly temperature.

WITH monthly_temperatures AS (
    SELECT
        TO_CHAR(TO_TIMESTAMP(dt), 'YYYY-MM') AS reading_month,
        name AS city,
        AVG(temperature - 273.15) AS average_temp
    FROM weather_raw
    GROUP BY
        TO_CHAR(TO_TIMESTAMP(dt), 'YYYY-MM'),
        name
),
ranked_cities AS (
    SELECT
        reading_month,
        city,
        average_temp,
        DENSE_RANK() OVER (
            PARTITION BY reading_month
            ORDER BY average_temp DESC
        ) AS city_rank
    FROM monthly_temperatures
)
SELECT
    reading_month,
    city,
    ROUND(average_temp::NUMERIC, 2) AS average_temp_celsius,
    city_rank
FROM ranked_cities
WHERE city_rank <= 3
ORDER BY reading_month, city_rank;


-- Q14. CITIES WITH THE MOST DATA GAPS
-- Define a data gap as more than 24 hours between readings.
-- LAG() finds the previous reading for each city.

WITH reading_gaps AS (
    SELECT
        name AS city,
        TO_TIMESTAMP(dt) AS reading_time,
        LAG(TO_TIMESTAMP(dt)) OVER (
            PARTITION BY name
            ORDER BY dt
        ) AS previous_reading
    FROM weather_raw
)
SELECT
    city,
    COUNT(*) FILTER (
        WHERE reading_time - previous_reading > INTERVAL '24 hours'
    ) AS gaps_over_24_hours
FROM reading_gaps
GROUP BY city
ORDER BY gaps_over_24_hours DESC;


-- Q15. CUSTOM BUSINESS QUESTION
-- Which cities have the highest number of hot and humid readings?
-- Define hot as above 30°C and humid as at least 70%.

SELECT
    name AS city,
    COUNT(*) AS hot_humid_readings,
    ROUND(AVG(temperature - 273.15)::NUMERIC, 2)
        AS average_temperature_celsius,
    ROUND(AVG(humidity), 2) AS average_humidity
FROM weather_raw
WHERE temperature > 303.15
  AND humidity >= 70
GROUP BY name
ORDER BY hot_humid_readings DESC;
