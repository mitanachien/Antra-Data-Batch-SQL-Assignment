SELECT Country, SUM(PickedQuantity) FROM
(SELECT JSON_VALUE(si.CustomFields, '$.CountryOfManufacture') AS Country, ol.PickedQuantity
FROM WideWorldImporters.Warehouse.StockItems si
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON si.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
WHERE DATEPART(YEAR, o.OrderDate) = 2015) AS Temp
GROUP BY Country;