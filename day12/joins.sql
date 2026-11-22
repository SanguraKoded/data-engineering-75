SELECT 
    Orders.OrdersID,
    Customers.CompanyName,
    Customers.CompanyName,
    Orders.OrderDate
FROM Orders
INNER JOIN Customers
    ON Orders.CustomerID = Customers.CustomerID;


SELECT
    Products.ProductID,
    Products.ProductName,
    OrderDetails.OrderID,
    OrderDetails.Quantity
FROM Products
LEFT JOIN OrderDetails
    ON Products.ProductID = OrderDetails.ProductID;

SELECT
    Employees.FirstName,
    Employees.LastName,
    Orders.OrderID,
    Customers.CompanyName,
    Orders.OrderDate
FROM Orders
INNER JOIN Employees
    ON Orders.EmployeeID = Employees.EmployeeID
INNER JOIN Customers
    ON Orders.CustomerID = Customers.CustomerID


SELECT
    Customers.CustomerID,
    Customers.CompanyName
FROM Customers
LEFT JOIN Orders
    ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;


/*
INNER JOIN vs LEFT JOIN

INNER JOIN returns only records that have matching
values in both tables.

LEFT JOIN returns all records from the left table,
even when there is no matching record in the right table.

I would use INNER JOIN when I only need matching records.
I would use LEFT JOIN when I need to preserve all records
from the main table, including unmatched records.
*/
