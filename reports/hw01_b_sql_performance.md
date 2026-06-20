# HW01-B — SQL Performance and Metabase

## Student schema
- schema: `student_nazanin_hesari`

## Baseline query
The baseline query reads directly from base tables in `core`:
- `core.listing`
- `core.calendar_day`
- `core.review`

It computes:
- listing count by neighbourhood
- average price
- median price
- average minimum nights
- total reviews
- reviews per listing
- 30-day availability rate

## Optimization approach
I created a materialized view:

- `student_nazanin_hesari.mv_airbnb_neighbourhood_summary`

This moves repeated aggregation work out of dashboard runtime and into a prepared database object.

### What changed
1. Precomputed the neighbourhood summary into a materialized view.
2. Added `availability_365_rate` so dashboard reads do not need extra aggregation.
3. Added indexes on:
   - `neighbourhood`
   - `num_listings DESC`

## Runtime comparison

### Baseline direct query
- runs: [0.48920740000903606, 0.45382860000245273, 0.41635060001863167]
- best_seconds: 0.4164
- avg_seconds: 0.4531

### Materialized view read
- runs: [0.17211500002304092, 0.18686419998994097, 0.18462059999001212, 0.15606550002121367, 0.1597654000215698]
- best_seconds: 0.1561
- avg_seconds: 0.1719

### Speedup
- speedup_vs_baseline_best: 2.6678x

## Explain-plan summary
- The baseline query performs repeated aggregation on large source tables.
- Median calculation with `PERCENTILE_CONT` adds extra sorting/ordering work inside groups.
- The materialized view reduces repeated work at dashboard read time.

## Metabase dashboard
Dashboard name:
- `QBC12 HW01 - sobhanjabari - Airbnb Ops`

Required screenshot path:
- `screenshots/metabase_dashboard.png`

Metabase link:
- http://185.50.38.163:33012

Required cards:
1. listings by neighbourhood
2. average price by neighbourhood
3. review activity by neighbourhood
4. availability rate by neighbourhood
5. top neighbourhoods table

## Notes
Because `core.listing` does not expose a text `neighbourhood` column in the shared schema I used `neighbourhood_id::text AS neighbourhood` in the output.