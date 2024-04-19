WITH CleanedSessions AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY SESSION_TIME_TS ASC) AS rn
    FROM {{ ref('base_web_schema__sessions') }}
),
CleanedOrders AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY ORDER_DATE_TS ASC) AS rn
    FROM {{ ref('base_web_schema__orders') }}
),
CleanedItemViews AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY ITEM_VIEW_TIME_TS ASC) AS rn
    FROM {{ ref('base_web_schema__item_views') }}
),
CleanedPageViews AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY VIEW_TIME_TS ASC) AS rn
    FROM {{ ref('base_web_schema__page_views') }}
)
SELECT 
    cs.SESSION_ID,
    cs.CLIENT_ID,
    co.ORDER_ID AS order_id,
    cs.IP,
    cs.OS,
    cs.SESSION_TIME_TS,
    cp.PAGE_NAME AS page_visited,
    ci.ITEM_NAME AS item_viewed,
    ci.ADD_TO_CART_QUANTITY AS items_added,
    ci.REMOVE_FROM_CART_QUANTITY AS items_removed,
    co.PAYMENT_METHOD AS payment_method_used,
    (CASE WHEN co.ORDER_ID IS NOT NULL THEN 1 ELSE 0 END) AS order_placed
FROM 
    CleanedSessions cs
LEFT JOIN CleanedPageViews cp ON cs.SESSION_ID = cp.SESSION_ID AND cp.rn = 1
LEFT JOIN CleanedItemViews ci ON cs.SESSION_ID = ci.SESSION_ID AND ci.rn = 1
LEFT JOIN CleanedOrders co ON cs.SESSION_ID = co.SESSION_ID AND co.rn = 1
WHERE 
    cs.rn = 1