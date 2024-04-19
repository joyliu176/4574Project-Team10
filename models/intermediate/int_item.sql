SELECT
    ITEM_NAME,
    ARRAY_AGG(DISTINCT PRICE_PER_UNIT) AS PRICE_ARRAY
FROM
    {{ ref('base_web_schema__item_views') }}
GROUP BY
    ITEM_NAME