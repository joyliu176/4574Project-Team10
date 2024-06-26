SELECT
    _FIVETRAN_ID,
    SESSION_ID,
    ITEM_VIEW_AT AS ITEM_VIEW_TIME_TS,
    ITEM_NAME,
    PRICE_PER_UNIT,
    REMOVE_FROM_CART_QUANTITY,
    ADD_TO_CART_QUANTITY,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS

FROM {{source('web_schema','item_views')}}