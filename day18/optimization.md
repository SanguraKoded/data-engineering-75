
## 1. Baseline and post-indexing results

| Query | Before (ms) | After (ms) | Plan after indexing |
|---|---:|---:|---|
| Filter by city | 0.150 | 0.071 | Seq Scan |
| Filter by timestamp | 0.077 | 0.062 | Seq Scan |
| Filter by city and sort by timestamp | 0.067 | 0.611 | Seq Scan + Sort |

## 2. Findings

PostgreSQL continued using sequential scans after the indexes were
created. It did not choose the individual city index, timestamp index,
or composite index for these queries.

This is expected because the weather_raw table contains only five
records. A sequential scan is inexpensive for such a small table.

The city query showed an observed execution-time decrease from
0.150 ms to 0.071 ms. The timestamp query decreased from 0.077 ms
to 0.062 ms. The city and sorting query increased from 0.067 ms
to 0.611 ms.

These differences are too small to establish a reliable performance
improvement or regression. They may be influenced by caching and
normal system variation.

## 3. Important observation

Creating an index does not force PostgreSQL to use it.
The query planner evaluates the estimated cost of available execution
plans and selects what it considers the cheapest option.

## 4. Conclusion

This experiment demonstrated that indexes do not automatically
improve every query. Their effectiveness depends on table size,
data distribution, query patterns and selectivity.

Indexes also require additional storage and maintenance during
inserts and updates. They should therefore be created based on
actual query requirements and measured performance.

### Additional experiment: ANALYZE

I executed:

ANALYZE weather_raw;

PostgreSQL reported zero rows updated and completed the operation successfully.

I reran the city-filter query using EXPLAIN ANALYZE.

The execution plan still showed a Sequential Scan, with an execution time of 0.075 ms.

This demonstrates that ANALYZE updates the database statistics used by the query planner, but does not force PostgreSQL to use an index.

Because the table contains only five records, a sequential scan remains an efficient choice.
