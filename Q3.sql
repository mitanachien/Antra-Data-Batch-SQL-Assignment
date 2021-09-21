(SELECT DISTINCT c.CustomerName FROM WideWorldImporters.Sales.Customers c
INNER JOIN WideWorldImporters.Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE OrderDate < '2016-01-01')
EXCEPT
(SELECT DISTINCT c.CustomerName FROM WideWorldImporters.Sales.Customers c
INNER JOIN WideWorldImporters.Sales.Orders o
ON c.CustomerID = o.CustomerID
WHERE OrderDate >= '2016-01-01');