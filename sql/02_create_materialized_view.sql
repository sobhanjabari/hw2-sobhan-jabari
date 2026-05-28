
DROP MATERIALIZED VIEW IF EXISTS "student_nazanin_hesari".mv_airbnb_neighbourhood_summary;

CREATE MATERIALIZED VIEW "student_nazanin_hesari".mv_airbnb_neighbourhood_summary AS
WITH calendar_30 AS (
    SELECT
        cd.listing_id,
        AVG(cd.price) AS avg_calendar_price_30,
        ROUND(
            SUM(CASE WHEN cd.available = true THEN 1 ELSE 0 END)::numeric
            / NULLIF(COUNT(*), 0)::numeric,
            4
        ) AS availability_30_rate
    FROM core.calendar_day cd
    WHERE cd.date >= (SELECT MIN(date) FROM core.calendar_day)
      AND cd.date <  (SELECT MIN(date) FROM core.calendar_day) + INTERVAL '30 days'
    GROUP BY cd.listing_id
),
calendar_365 AS (
    SELECT
        cd.listing_id,
        ROUND(
            SUM(CASE WHEN cd.available = true THEN 1 ELSE 0 END)::numeric
            / NULLIF(COUNT(*), 0)::numeric,
            4
        ) AS availability_365_rate
    FROM core.calendar_day cd
    GROUP BY cd.listing_id
),
review_counts AS (
    SELECT
        r.listing_id,
        COUNT(*) AS total_reviews
    FROM core.review r
    GROUP BY r.listing_id
)
SELECT
    l.neighbourhood_id::text AS neighbourhood,
    COUNT(l.listing_id) AS num_listings,
    ROUND(AVG(l.listing_price), 2) AS avg_price,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY l.listing_price) AS median_price,
    ROUND(AVG(l.minimum_nights::numeric), 2) AS avg_minimum_nights,
    COALESCE(SUM(rc.total_reviews), 0) AS total_reviews,
    ROUND(
        COALESCE(SUM(rc.total_reviews), 0)::numeric
        / NULLIF(COUNT(l.listing_id), 0)::numeric,
        2
    ) AS reviews_per_listing,
    ROUND(AVG(c30.availability_30_rate), 4) AS availability_30_rate,
    ROUND(AVG(c365.availability_365_rate), 4) AS availability_365_rate
FROM core.listing l
LEFT JOIN calendar_30 c30
    ON c30.listing_id = l.listing_id
LEFT JOIN calendar_365 c365
    ON c365.listing_id = l.listing_id
LEFT JOIN review_counts rc
    ON rc.listing_id = l.listing_id
GROUP BY l.neighbourhood_id
ORDER BY num_listings DESC;

CREATE INDEX idx_nazanin_hesari_mv_airbnb_neighbourhood
    ON "student_nazanin_hesari".mv_airbnb_neighbourhood_summary (neighbourhood);

CREATE INDEX idx_nazanin_hesari_mv_airbnb_num_listings
    ON "student_nazanin_hesari".mv_airbnb_neighbourhood_summary (num_listings DESC);
