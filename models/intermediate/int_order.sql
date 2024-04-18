WITH CleanedOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY ORDER_DATE_TS ASC) AS rn
    FROM {{ ref('base_web_schema__orders') }}
),
ItemCalculations AS (
    SELECT 
        SESSION_ID,
        PRICE_PER_UNIT,
        (SUM(ADD_TO_CART_QUANTITY) - SUM(REMOVE_FROM_CART_QUANTITY)) AS final_quantity,
        SUM(PRICE_PER_UNIT * ADD_TO_CART_QUANTITY) AS total_added_price,
        SUM(PRICE_PER_UNIT * REMOVE_FROM_CART_QUANTITY) AS total_removed_price
    FROM {{ ref('base_web_schema__item_views') }}
    GROUP BY SESSION_ID, PRICE_PER_UNIT
)

SELECT 
    o.SESSION_ID,
    o.CLIENT_NAME,
    o.ORDER_DATE_TS,
    o.PAYMENT_METHOD,
    o.SHIPPING_ADDRESS,
    o.PHONE,
    ic.PRICE_PER_UNIT,
    ic.final_quantity,
    ic.total_added_price - ic.total_removed_price AS net_item_price,
    o.SHIPPING_COST,
    o.TAX_RATE,
    (ic.total_added_price - ic.total_removed_price) * (1 + o.TAX_RATE) + o.SHIPPING_COST AS total_paid
FROM CleanedOrders o
JOIN ItemCalculations ic ON o.SESSION_ID = ic.SESSION_ID
WHERE o.rn = 1