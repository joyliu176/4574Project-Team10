SELECT 
    DATE(ORDER_DATE_TS) AS transaction_date,
    SUM(NET_ITEM_PRICE) AS total_revenue,
    SUM(NET_ITEM_PRICE * TAX_RATE) AS total_taxes,
    SUM(SHIPPING_COST) AS total_shipping_costs,
    SUM(TOTAL_PAID) AS total_collected
FROM {{ ref('int_order') }}
GROUP BY DATE(ORDER_DATE_TS)
