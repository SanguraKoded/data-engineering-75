WITH ProductRevenue AS (
    SELECT
        p.CategoryID,
        od.UnitPrice * od.Quantity * (1 - od.Discount)
            AS line_revenue
    FROM Products p
    INNER JOIN OrderDetails od
        ON p.ProductID = od.ProductID
)
SELECT
    c.CategoryName,
    ROUND(SUM(pr.line_revenue), 2) AS total_revenue
FROM ProductRevenue pr
INNER JOIN Categories c
    ON pr.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY total_revenue DESC;

WITH FilteredOrders AS (
    SELECT
        OrderID,
        CustomerID
    FROM Orders
    WHERE OrderDate >= '1997-01-01'
),
CustomerSpending AS (
    SELECT
        fo.CustomerID,
        SUM(
            od.UnitPrice * od.Quantity * (1 - od.Discount)
        ) AS total_spending
    FROM FilteredOrders fo
    INNER JOIN OrderDetails od
        ON fo.OrderID = od.OrderID
    GROUP BY fo.CustomerID
),
CustomerResults AS (
    SELECT
        c.CustomerID,
        c.CompanyName,
        cs.total_spending
    FROM CustomerSpending cs
    INNER JOIN Customers c
        ON cs.CustomerID = c.CustomerID
)
SELECT
    CustomerID,
    CompanyName,
    ROUND(total_spending, 2) AS total_spending
FROM CustomerResults
ORDER BY total_spending DESC;

WITH RECURSIVE Numbers(number) AS (
    SELECT 1

    UNION ALL

    SELECT number + 1
    FROM Numbers
    WHERE number < 10
)
SELECT number
FROM Numbers;

SELECT
    p.ProductName,
    p.CategoryID,
    p.UnitPrice
FROM Products p
WHERE p.UnitPrice > (
    SELECT AVG(p2.UnitPrice)
    FROM Products p2
    WHERE p2.CategoryID = p.CategoryID
);

WITH CategoryAverages AS (
    SELECT
        CategoryID,
        AVG(UnitPrice) AS average_price
    FROM Products
    GROUP BY CategoryID
)
SELECT
    p.ProductName,
    p.CategoryID,
    p.UnitPrice,
    ROUND(ca.average_price, 2) AS category_average
FROM Products p
INNER JOIN CategoryAverages ca
    ON p.CategoryID = ca.CategoryID
WHERE p.UnitPrice > ca.average_price
ORDER BY p.CategoryID, p.UnitPrice DESC;