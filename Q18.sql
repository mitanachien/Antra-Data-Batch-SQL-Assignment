CREATE VIEW QuantityByYears AS
SELECT StockGroupName, [2013], [2014], [2015], [2016], [2017]
FROM(
SELECT sg.StockGroupName, DATEPART(YEAR, o.OrderDate) AS Year, ol.Quantity
FROM WideWorldImporters.Warehouse.StockItems si
INNER JOIN WideWorldImporters.Warehouse.StockItemStockGroups sisg
ON si.StockItemID = sisg.StockItemID
INNER JOIN WideWorldImporters.Warehouse.StockGroups sg
ON sisg.StockGroupID = sg.StockGroupID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON si.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID) AS Temp
PIVOT
(
SUM(Quantity)
FOR Year IN ([2013], [2014], [2015], [2016], [2017])
) AS PivotTables;
