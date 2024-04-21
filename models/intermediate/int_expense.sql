SELECT
    ROW_NUMBER() OVER (ORDER BY DATE, EXPENSE_TYPE) AS row_num,
    EXPENSE_TYPE,
    TOTAL_AMOUNT,
    DATE
FROM (
    SELECT 
        EXPENSE_TYPE,
        SUM(EXPENSE_AMOUNT) AS TOTAL_AMOUNT,
        DATE
    FROM 
        {{ ref('base_google_drive__expenses') }}
    GROUP BY 
        DATE, EXPENSE_TYPE
) AS subquery
ORDER BY 
    DATE, EXPENSE_TYPE
