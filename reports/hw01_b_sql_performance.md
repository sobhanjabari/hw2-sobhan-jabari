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
- runs: [0.4480480000056559, 0.48890949999622535, 0.4813768999883905]
- best_seconds: 0.4480
- avg_seconds: 0.4728

### Materialized view read
- runs: [0.2517299000028288, 0.2022125999937998, 0.18000710000342224, 0.17782319999241736, 0.18008560000453144]
- best_seconds: 0.1778
- avg_seconds: 0.1984

### Speedup
- speedup_vs_baseline_best: 2.5196x

## Explain-plan summary
- The baseline query performs repeated aggregation on large source tables.
- Median calculation with `PERCENTILE_CONT` adds extra sorting/ordering work inside groups.
- The materialized view reduces repeated work at dashboard read time.

## Metabase dashboard
Dashboard name:
- `QBC12 HW01 - <your-github-username> - Airbnb Ops`

Required screenshot path:
- `screenshots/metabase_dashboard.png`

Metabase link:
- Paste your Metabase dashboard URL here

## Notes
Because `core.listing` does not expose a text `neighbourhood` column in the shared schema I used `neighbourhood_id::text AS neighbourhood` in the output.