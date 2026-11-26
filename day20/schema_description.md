
# Day 20 — Star Schema Design (Weather Dataset)

## Overview

This is a star schema for weather data. The central fact table `fact_weather`
records individual weather observations (the measurements). Three dimension
tables — `dim_date`, `dim_city`, and `dim_condition` — surround it and provide
the descriptive context (when, where, and what kind of weather). This is a
star schema because each dimension is flat (no sub-dimensions), so every
dimension joins directly to the fact table with a single join.

## Fact Table: `fact_weather`

Stores one row per weather observation. Contains the measures and three
foreign keys linking to the dimensions.

+----------------+---------------------+------------------------------------------+
| Column         | Key                 | Description                              |
+----------------+---------------------+------------------------------------------+
| id             | PK                  | Unique identifier for each observation   |
| date_key       | FK -> dim_date      | The date of the observation              |
| city_key       | FK -> dim_city      | The city where it was observed            |
| condition_key   | FK -> dim_condition | The weather condition recorded            |
| temp           | Measure             | Temperature                              |
| humidity       | Measure             | Humidity level                           |
| pressure       | Measure             | Atmospheric pressure                      |
| wind_speed     | Measure             | Wind speed                               |
+----------------+---------------------+------------------------------------------+

## Dimension Tables

### `dim_date` — the "when"

+--------------+-----------+-------------------------------------------+
| Column       | Key       | Description                               |
+--------------+-----------+-------------------------------------------+
| date_key     | PK        | Unique date identifier                    |
| date         | Attribute | Full date                                 |
| day          | Attribute | Day of month                              |
| month        | Attribute | Month                                     |
| year         | Attribute | Year                                      |
| quarter      | Attribute | Fiscal/calendar quarter                   |
| is_weekend   | Attribute | True if Saturday/Sunday                   |
+--------------+-----------+-------------------------------------------+

### `dim_city` — the "where"

+--------------+-----------+-------------------------------------------+
| Column       | Key       | Description                               |
+--------------+-----------+-------------------------------------------+
| city_key     | PK        | Unique city identifier                    |
| city_name    | Attribute | Name of the city                          |
| country      | Attribute | Country                                   |
| region       | Attribute | Geographic region                         |
| latitude     | Attribute | Latitude coordinate                       |
| longitude    | Attribute | Longitude coordinate                      |
+--------------+-----------+-------------------------------------------+

### `dim_condition` — the "what kind of weather"

+----------------+-----------+-------------------------------------------+
| Column         | Key       | Description                               |
+----------------+-----------+-------------------------------------------+
| condition_key   | PK        | Unique condition identifier                |
| description     | Attribute | e.g. sunny, rainy, cloudy                 |
| category       | Attribute | hot / warm / cool                         |
+----------------+-----------+-------------------------------------------+

## Primary Keys and Foreign Keys

Primary keys:
- `fact_weather.id`
- `dim_date.date_key`
- `dim_city.city_key`
- `dim_condition.condition_key`

Foreign keys:
- `fact_weather.date_key` -> `dim_date.date_key`
- `fact_weather.city_key` -> `dim_city.city_key`
- `fact_weather.condition_key` -> `dim_condition.condition_key`

## Why This Is a Star Schema

The fact table sits in the center with three dimension tables radiating
outward, forming a star. Each dimension connects directly to the fact with
one join and contains no further sub-dimensions. (If `dim_city` were split
into `city -> region -> country`, it would become a snowflake schema.)
