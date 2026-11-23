WITH EmployeeSalaries AS (
    SELECT 'John' AS employee, 'Sales' AS department, 5000 AS salary
    UNION ALL
    SELECT 'Mary', 'Sales', 6000
    UNION ALL
    SELECT 'Peter', 'Sales', 5500
    UNION ALL
    SELECT 'Jane', 'IT', 7000
    UNION ALL
    SELECT 'David', 'IT', 6500
)
SELECT
    employee,
    department,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department
        ORDER BY salary DESC
    ) AS employee_rank
FROM EmployeeSalaries;


WITH EmployeeSalaries AS (
    SELECT 'John' AS employee, 5000 AS salary
    UNION ALL
    SELECT 'Mary', 6000
    UNION ALL
    SELECT 'Peter', 6000
    UNION ALL
    SELECT 'Jane', 4500
)
SELECT
    employee,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM EmployeeSalaries;

WITH EmployeeSalaries AS (
    SELECT 'John' AS employee, 5000 AS salary
    UNION ALL
    SELECT 'Mary', 6000
    UNION ALL
    SELECT 'Peter', 6000
    UNION ALL
    SELECT 'Jane', 4500
)
SELECT
    employee,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM EmployeeSalaries;

WITH MonthlyRevenue AS (
    SELECT
        STRFTIME('%Y-%m', o.OrderDate) AS order_month,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS revenue
    FROM Orders o
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY STRFTIME('%Y-%m', o.OrderDate)
)
SELECT
    order_month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        LAG(revenue) OVER (ORDER BY order_month),
        2
    ) AS previous_month_revenue,
    ROUND(
        revenue - LAG(revenue) OVER (ORDER BY order_month),
        2
    ) AS revenue_change
FROM MonthlyRevenue
ORDER BY order_month;

WITH MonthlyRevenue AS (
    SELECT
        STRFTIME('%Y-%m', o.OrderDate) AS order_month,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS revenue
    FROM Orders o
    INNER JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY STRFTIME('%Y-%m', o.OrderDate)
)
SELECT
    order_month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (
            ORDER BY order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS running_total
FROM MonthlyRevenue
ORDER BY order_month;


/*
DAY 14 — SQL WINDOW FUNCTIONS

ROW_NUMBER():
Assigns a unique sequential number to each row.

RANK():
Ranks rows and leaves gaps after tied positions.

DENSE_RANK():
Ranks rows without leaving gaps after ties.

LAG():
Accesses a value from a previous row.

LEAD():
Accesses a value from a subsequent row.

PARTITION BY:
Divides rows into groups for window calculations.

ORDER BY:
Controls the order in which window calculations operate.

Running Total:
Uses SUM() OVER() to accumulate values across ordered rows.

GROUP BY vs WINDOW FUNCTIONS:
GROUP BY combines rows into summary groups.
Window functions retain individual rows while calculating
values across related rows.
*/