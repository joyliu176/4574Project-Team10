SELECT 
    s.client_id, 
    s.ip, 
    o.shipping_address, 
    o.state, 
    o.client_name, 
    o.phone
FROM {{ ref('base_web_schema__sessions') }} s
INNER JOIN {{ ref('base_web_schema__orders') }} o
    ON s.session_id = o.session_id
INNER JOIN (
    SELECT 
        s_inner.client_id, 
        MAX(o_inner.order_date_ts) AS max_order_date_ts
    FROM {{ ref('base_web_schema__sessions') }} s_inner
    INNER JOIN {{ ref('base_web_schema__orders') }} o_inner
        ON s_inner.session_id = o_inner.session_id
    GROUP BY s_inner.client_id
) AS latest
    ON s.client_id = latest.client_id 
    AND o.order_date_ts = latest.max_order_date_ts