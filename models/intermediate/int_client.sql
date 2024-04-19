WITH OrderSessionInfo AS (
  SELECT
    s.client_id,
    s.ip,
    s.os,
    o.client_name,
    o.phone,
    o.payment_method,
    o.payment_info,
    o.shipping_address,
    o.state,
    o.order_date_ts,
    ROW_NUMBER() OVER (PARTITION BY s.client_id ORDER BY o.order_date_ts DESC) AS rn
  FROM {{ ref('base_web_schema__orders') }} o
  JOIN {{ ref('base_web_schema__sessions') }} s
    ON o.session_id = s.session_id
)
SELECT
  client_id,
  ip,
  os,
  client_name,
  phone,
  payment_method,
  payment_info,
  shipping_address,
  state
FROM OrderSessionInfo
WHERE rn = 1