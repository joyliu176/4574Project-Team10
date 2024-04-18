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
    s.SESSION_ID,
    s.CLIENT_ID,
    s.IP,
    s.OS,
    s.SESSION_TIME_TS,
    COUNT(DISTINCT p.PAGE_NAME) AS num_pages_visited,
    ARRAY_AGG(DISTINCT p.PAGE_NAME) AS pages_visited,
    SUM(i.ADD_TO_CART_QUANTITY) AS total_items_added,
    SUM(i.REMOVE_FROM_CART_QUANTITY) AS total_items_removed,
    total_items_added - total_items_removed AS total_items,
    COUNT(DISTINCT o.ORDER_DATE_TS) AS num_orders,
    ARRAY_AGG(DISTINCT o.PAYMENT_METHOD) AS payment_methods_used
FROM 
    CleanedSessions s
LEFT JOIN CleanedPageViews p ON s.SESSION_ID = p.SESSION_ID AND p.rn = 1
LEFT JOIN CleanedItemViews i ON s.SESSION_ID = i.SESSION_ID AND i.rn = 1
LEFT JOIN CleanedOrders o ON s.SESSION_ID = o.SESSION_ID AND o.rn = 1
WHERE 
    s.rn = 1
GROUP BY 
    s.SESSION_ID, s.CLIENT_ID, s.IP, s.OS, s.SESSION_TIME_TS
HAVING 
    COUNT(DISTINCT p.PAGE_NAME) IS NOT NULL