-- Define Common Table Expressions (CTEs) for cleaned data
WITH CleanedSessions AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY SESSION_ID ORDER BY SESSION_TIME_TS ASC) AS rn
    FROM {{ ref('base_web_schema__sessions') }}
),
CleanedOrders AS (
    SELECT *
    FROM {{ ref('base_web_schema__orders') }}
),
CleanedItemViews AS (
    SELECT SESSION_ID,
           LISTAGG(ITEM_NAME, ', ') WITHIN GROUP (ORDER BY ITEM_VIEW_TIME_TS) AS item_viewed,
           COALESCE(SUM(ADD_TO_CART_QUANTITY), 0) AS total_added_to_cart,
           COALESCE(SUM(REMOVE_FROM_CART_QUANTITY), 0) AS total_removed_from_cart
    FROM {{ ref('base_web_schema__item_views') }}
    GROUP BY SESSION_ID
),
CleanedPageViews AS (
    SELECT SESSION_ID,
           LISTAGG(PAGE_NAME, ', ') WITHIN GROUP (ORDER BY VIEW_TIME_TS) AS page_visited
    FROM {{ ref('base_web_schema__page_views') }}
    GROUP BY SESSION_ID
)
-- Main select query to fetch the required information
SELECT 
    cs.SESSION_ID,
    cs.CLIENT_ID,
    co.ORDER_ID AS order_id,
    cs.IP,
    cs.OS,
    cs.SESSION_TIME_TS,
    cp.page_visited,
    ci.item_viewed,
    ci.total_added_to_cart AS items_added,
    ci.total_removed_from_cart AS items_removed,
    co.PAYMENT_METHOD AS payment_method_used,
    (CASE WHEN co.ORDER_ID IS NOT NULL THEN 1 ELSE 0 END) AS order_placed
FROM 
    CleanedSessions cs
LEFT JOIN CleanedPageViews cp ON cs.SESSION_ID = cp.SESSION_ID 
LEFT JOIN CleanedOrders co ON cs.SESSION_ID = co.SESSION_ID
LEFT JOIN CleanedItemViews ci ON cs.SESSION_ID = ci.SESSION_ID
WHERE 
    cs.rn = 1
