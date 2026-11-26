# Day 19 — OLTP vs OLAP

## What is OLTP?

OLTP (Online Transaction Processing) is a data processing system built for the real-time execution of large numbers of small, simple database transactions by many users at once. It is purely operational: it records day-to-day business activity with response times measured in milliseconds, using a relational database to handle inserts, updates, and deletes while guaranteeing data integrity and fast indexed retrieval. The people who use OLTP systems are front-line workers such as cashiers, bank tellers, and hotel desk clerks, or customers serving themselves through self-service apps.

**Real example 1 — ATM withdrawal.** The system instantly verifies your balance, deducts the cash, and records the transaction, all in under a second. If the money came out but the balance were not updated, that would be a serious failure, which is exactly what OLTP is designed to prevent.

**Real example 2 — Hotel reservation.** The system checks availability, locks the room so no one else books it, takes payment, and confirms the booking in real time, all while many other guests are booking at the same moment.

## What is OLAP?

OLAP (Online Analytical Processing) is a system for performing multi-dimensional analysis at high speed on large volumes of data, typically sourced from a data warehouse, data mart, or other centralized store. Its core is the OLAP cube, which extends the row-by-column table format with extra layers for other dimensions such as region, time of year, and product model. This lets an analyst start at sales by region and drill down into sales by state, city, or specific store. OLAP is used by data scientists, business analysts, and knowledge workers who need insight rather than operations.

**Real example 1 — Sales forecasting and budgeting.** An analyst slices years of sales data by region, product, and season to predict demand and allocate budgets for the coming year.

**Real example 2 — Financial analysis reporting.** A company aggregates figures across departments to report on profitability, spending trends, and overall performance, turning raw stored data into decisions.

## Key Differences

**Write patterns.** OLTP handles frequent, small, simple writes — a single insert, update, or delete — many times per second from many users at once. OLAP, by contrast, receives bulk loads of large data volumes that arrive periodically, such as a nightly load from the operational systems, rather than one row at a time.

**Read patterns.** OLTP reads are simple indexed lookups that return a few rows, such as fetching one customer's balance. OLAP reads are complex queries that scan enormous datasets and aggregate the results, such as total sales by region per quarter over three years compared against forecast.

**Normalization.** OLTP databases are highly normalized, typically to third normal form, so data is split into tidy tables to avoid duplication and protect integrity — critical when records are being updated live. OLAP databases are often deliberately denormalized using star or snowflake schemas, because fewer joins mean faster analytical queries; speed of reading matters more than tidiness of storage.

## PostgreSQL vs Redshift

PostgreSQL is an OLTP database. It is a row-oriented relational database optimized for fast transactional writes, point queries, and ACID compliance, which is exactly the workload of an ATM or booking system.

Amazon Redshift is an OLAP database. It is a column-oriented data warehouse optimized for analytical queries over large volumes of data, using compression and massively parallel processing to speed up aggregations and full scans.

## Diagram
Attached in dir day19/