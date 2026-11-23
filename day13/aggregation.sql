SELECT
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) 
        AS total_revenue
FROM Categories c
INNER JOIN Products p
    ON c.CategoryID = p.CategoryID
INNER JOIN [Order Details] od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY total_revenue DESC;

WITH OrderTotals AS (
    SELECT
        o.OrderID,
        o.CustomerID,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal
    FROM Orders o
    INNER JOIN [Order Details] od
        ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.CustomerID
)
SELECT
    c.CustomerID,
    c.CompanyName,
    ROUND(SUM(ot.OrderTotal), 2)  AS TotalSpent,
    ROUND(AVG(ot.OrderTotal), 2)  AS average_order_value
FROM Customers c
INNER JOIN OrderTotals ot
    ON c.CustomerID = ot.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(*) > 100
ORDER BY average_order_value DESC;

SELECT
    STRFTIME('%Y-%m', o.OrderDate) AS order_month,
    COUNT(o.OrderID) AS total_orders
FROM Orders o
GROUP BY STRFTIME('%Y-%m', o.OrderDate)
ORDER BY order_month;


SELECT
    c.CustomerID,
    c.CompanyName,
    ROUND(
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2
    ) AS total_spending
FROM Customers c
INNER JOIN Orders o
    ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_spending DESC
LIMIT 5;


SELECT
c.CategoryName,
ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_sales
FROM Categories c
INNER JOIN Products p
    ON c.CategoryID = p.CategoryID  
INNER JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 10000
ORDER BY total_sales DESC;

/*
DAY 13 — SQL AGGREGATIONS

GROUP BY:
Groups records sharing the same value so aggregate
functions can calculate results for each group.

COUNT:
Counts records.

SUM:
Adds numeric values.

AVG:
Calculates the average of numeric values.

MIN and MAX:
Find the smallest and largest values.

WHERE vs HAVING:
WHERE filters individual records before grouping.
HAVING filters groups after aggregation.

Revenue calculation:
UnitPrice * Quantity * (1 - Discount)
*/