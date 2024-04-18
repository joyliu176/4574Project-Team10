WITH CleanedReturns AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY RETURNED_DATE ASC) AS rn
    FROM {{ ref('base_google_drive__returns') }}
)

SELECT 
    ORDER_ID,
    RETURNED_DATE,
    IS_REFUNDED
FROM CleanedReturns
WHERE rn = 1