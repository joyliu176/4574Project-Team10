SELECT 
    ITEM_NAME,
    ARRAY_AGG(DISTINCT PRICE_PER_UNIT) AS price_array
FROM (
    SELECT 
        ITEM_NAME,
        PRICE_PER_UNIT
    FROM {{ ref('base_web_schema__item_views') }}
    ORDER BY ITEM_NAME, PRICE_PER_UNIT
)
GROUP BY ITEM_NAME
