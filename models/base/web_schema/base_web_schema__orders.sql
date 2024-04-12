SELECT
    _FIVETRAN_ID,
    SHIPPING_ADDRESS,
    PAYMENT_INFO,
    STATE,
    ORDER_AT AS ORDER_DATE_TS,
    SESSION_ID,
    CLIENT_NAME,
    CAST(REPLACE(SHIPPING_COST, 'USD ', '') AS DECIMAL(10,2)) AS SHIPPING_COST,
    PAYMENT_METHOD,
    TAX_RATE,
    PHONE,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED AS FIVVETRAN_SYNCED_TS

FROM {{ source('web_schema', 'orders') }}