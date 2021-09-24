--Use EXCEPT to remove items which sold to Alabama and Georgia in 2014

SELECT DISTINCT StockItemName FROM WideWorldImporters.Warehouse.StockItems s
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON s.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
WHERE DATEPART(YEAR, o.OrderDate) = '2014'
EXCEPT
SELECT DISTINCT StockItemName FROM WideWorldImporters.Warehouse.StockItems s
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON s.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
INNER JOIN WideWorldImporters.Sales.Customers c
ON o.CustomerID = c.CustomerID
INNER JOIN WideWorldImporters.Application.Cities c2
ON c.DeliveryCityID = c2.CityID
INNER JOIN WideWorldImporters.Application.StateProvinces st
ON c2.StateProvinceID = st.StateProvinceID
WHERE DATEPART(YEAR, o.OrderDate) = '2014'
AND st.StateProvinceName IN ('Alabama', 'Georgia');