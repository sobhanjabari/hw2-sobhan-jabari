# HW01-B — SQL Performance and Metabase

This repository contains the HW01-B SQL performance work for the QBC12 Airbnb database assignment.

## Contents

- `02_sql_performance_metabase_student.ipynb` — notebook used to inspect tables, build SQL, measure latency, create the materialized view, and write reports.
- `sql/01_baseline_neighbourhood_summary.sql` — baseline neighbourhood summary query against `core` tables.
- `sql/02_create_materialized_view.sql` — materialized-view creation script plus supporting indexes.
- `reports/baseline_explain_analyze.txt` — `EXPLAIN (ANALYZE, BUFFERS)` output for the baseline query.
- `reports/explain_notes.md` — specific observations from the query plan.
- `reports/hw01_b_sql_performance.md` — final performance report.
- `screenshots/metabase_dashboard.png` — required Metabase dashboard screenshot once exported.

## Dashboard

Expected dashboard name:

```text
QBC12 HW01 - sobhanjabari - Airbnb Ops
```

Required dashboard cards:

1. listings by neighbourhood
2. average price by neighbourhood
3. review activity by neighbourhood
4. availability rate by neighbourhood
5. top neighbourhoods table

## Notes

- Database credentials should be provided through environment variables or a local, untracked `param.env` file.
- Do not commit passwords or screenshots that expose credentials.