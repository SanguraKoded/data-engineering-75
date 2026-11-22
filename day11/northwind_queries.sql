SELECT *
FROM Customers
WHERE Country = 'Germany';

SELECT ProductName, UnitPrice
FROM Products
ORDER BY UnitPrice DESC
LIMIT 10;

SELECT
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS total_orders
FROM Customers c
LEFT JOIN Orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_orders DESC;

SELECT *
FROM Employees
WHERE LastName LIKE 'D%';
