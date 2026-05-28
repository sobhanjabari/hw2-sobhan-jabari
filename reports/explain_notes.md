# EXPLAIN notes

## Observation 1
The baseline query aggregates `core.calendar_day` for the first 30 days and `core.review` for all reviews before joining to `core.listing`.
This means the query still scans large base tables each time the dashboard query runs.

## Observation 2
The median calculation uses:
`PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY l.listing_price)`
which requires ordered work inside each neighbourhood group and is more expensive than simple aggregates like AVG or COUNT.

## Observation 3
Even though review and calendar metrics are pre-aggregated in CTEs, the full aggregation work is repeated on every execution of the baseline query.
This is a good candidate for a materialized view because dashboard users usually read summary data many times while source tables change less frequently.