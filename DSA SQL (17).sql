WITH summary AS (
    SELECT

        SUM(CASE
            WHEN item_type = 'prime_eligible'
            THEN square_footage ELSE 0
        END) AS sqrt_prime,

        SUM(CASE
            WHEN item_type = 'prime_eligible'
            THEN 1 ELSE 0
        END) AS prime_count,

        SUM(CASE
            WHEN item_type = 'not_prime'
            THEN square_footage ELSE 0
        END) AS sqrt_non_prime,

        SUM(CASE
            WHEN item_type = 'not_prime'
            THEN 1 ELSE 0
        END) AS non_prime_count

    FROM inventory
),

prime_calc AS (
    SELECT *,
        FLOOR(500000 / sqrt_prime) AS prime_batches
    FROM summary
),

remaining AS (
    SELECT *,
        500000 - (prime_batches * sqrt_prime)
        AS remaining_space
    FROM prime_calc
)

SELECT
    'prime_eligible' AS item_type,
    prime_batches * prime_count AS item_count
FROM remaining

UNION ALL

SELECT
    'not_prime' AS item_type,
    FLOOR(remaining_space / sqrt_non_prime)
    * non_prime_count AS item_count
FROM remaining;