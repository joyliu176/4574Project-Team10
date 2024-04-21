-- Calculate daily expenses
WITH DailyExpenses AS (
    SELECT
        DATE,
        SUM(TOTAL_AMOUNT) AS TotalDailyExpense
    FROM {{ ref('int_expense') }}
    GROUP BY DATE
),
-- Use a recursive CTE to create a series of dates and calculate daily salary for each employee
DailyEmployeeSalaries AS (
    WITH RECURSIVE DateRange(Date) AS (
        SELECT MIN(HIRE_DATE) FROM {{ ref('int_employee') }}
        UNION ALL
        SELECT DATEADD(day, 1, Date) FROM DateRange
        WHERE DATEADD(day, 1, Date) <= CURRENT_DATE()
    ),
    DailySalaries AS (
        SELECT
            DR.Date AS salary_date,
            I.ANNUAL_SALARY / 365 AS DailySalary
        FROM
            DateRange DR
            CROSS JOIN {{ ref('int_employee') }} I
        WHERE
            DR.Date BETWEEN I.HIRE_DATE AND NVL(I.QUIT_DATE, CURRENT_DATE())
    )
    SELECT
        salary_date,
        SUM(DailySalary) AS TotalDailyEmployeeSalary
    FROM
        DailySalaries
    GROUP BY
        salary_date
),
-- Calculate daily order values
DailyOrderValues AS (
    SELECT
        DATE(ORDER_DATE_TS) AS order_date,
        SUM(TOTAL_ORDER_VALUE) AS DailyTotalOrderValue
    FROM {{ ref('int_order') }}
    GROUP BY DATE(ORDER_DATE_TS)
),
-- Calculate daily refunds
DailyRefunds AS (
    SELECT
        DATE(RETURNED_DATE) AS refund_date,
        SUM(TOTAL_ORDER_VALUE) AS TotalDailyRefunds
    FROM {{ ref('int_return') }} r
    JOIN {{ ref('int_order') }} o ON r.ORDER_ID = o.ORDER_ID
    WHERE IS_REFUNDED = 'yes'
    GROUP BY DATE(RETURNED_DATE)
)
-- Select and combine all daily data
SELECT
    COALESCE(e.DATE, s.salary_date, o.order_date, r.refund_date) AS Date,
    COALESCE(e.TotalDailyExpense, 0) AS Daily_Expense,
    COALESCE(s.TotalDailyEmployeeSalary, 0) AS Daily_Employee_Salary,
    COALESCE(o.DailyTotalOrderValue, 0) - COALESCE(r.TotalDailyRefunds, 0) AS Daily_Revenue,
    COALESCE(r.TotalDailyRefunds, 0) AS Daily_Refunds,
    (Daily_Revenue - Daily_Expense - Daily_Employee_Salary - Daily_Refunds) AS Profit
FROM DailyExpenses e
FULL OUTER JOIN DailyEmployeeSalaries s ON e.DATE = s.salary_date
FULL OUTER JOIN DailyOrderValues o ON COALESCE(e.DATE, s.salary_date) = o.order_date
FULL OUTER JOIN DailyRefunds r ON COALESCE(e.DATE, s.salary_date, o.order_date) = r.refund_date
ORDER BY Date
