WITH cte AS 
(SELECT CustomerName, SUM(ol.PickedQuantity) AS Total
FROM WideWorldImporters.Sales.Customers c
INNER JOIN WideWorldImporters.Sales.Orders o
ON c.CustomerID = o.CustomerID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON o.OrderID = ol.OrderID
INNER JOIN WideWorldImporters.Warehouse.StockItems s
ON ol.StockItemID = s.StockItemID
WHERE s.StockItemName LIKE '%mug%'
AND DATEPART(YEAR, o.OrderDate) = 2016
GROUP BY CustomerName
HAVING SUM(ol.PickedQuantity) <= 10)

SELECT a.CustomerName, c.PhoneNumber, p.FullName 
FROM cte AS a
LEFT JOIN WideWorldImporters.Sales.Customers c
ON a.CustomerName = c.CustomerName
INNER JOIN WideWorldImporters.Application.People p
ON c.PrimaryContactPersonID = p.PersonID;