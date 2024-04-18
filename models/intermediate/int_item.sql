SELECT 
    ITEM_NAME,
    ARRAY_AGG(DISTINCT PRICE_PER_UNIT) AS price_array,
    SUM(ADD_TO_CART_QUANTITY) AS total_added_to_cart,
    SUM(REMOVE_FROM_CART_QUANTITY) AS total_removed_from_cart,
    COUNT(*) AS total_views,
FROM (
    SELECT 
        ITEM_NAME,
        PRICE_PER_UNIT,
        ADD_TO_CART_QUANTITY,
        REMOVE_FROM_CART_QUANTITY
    FROM {{ ref('base_web_schema__item_views') }}
    ORDER BY ITEM_NAME, PRICE_PER_UNIT
)
GROUP BY ITEM_NAME