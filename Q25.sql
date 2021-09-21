DECLARE @GroupName NVARCHAR(MAX) = '', @sql NVARCHAR(MAX);
SELECT @GroupName += QUOTENAME(StockGroupName) + ','
FROM (SELECT StockGroupName
FROM WideWorldImporters.Warehouse.StockGroups sg
GROUP BY StockGroupName) AS Temp

SET @GroupName = LEFT(@GroupName, LEN(@GroupName)-1);

SET @sql = 'SELECT *
FROM
(
SELECT sg.StockGroupName, DATEPART(YEAR, o.OrderDate) AS Year, ol.PickedQuantity
FROM WideWorldImporters.Warehouse.StockItems si
INNER JOIN WideWorldImporters.Warehouse.StockItemStockGroups sisg
ON si.StockItemID = sisg.StockItemID
INNER JOIN WideWorldImporters.Warehouse.StockGroups sg
ON sisg.StockGroupID = sg.StockGroupID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON si.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
) AS Temp
PIVOT
(
  SUM(PickedQuantity) FOR StockGroupName IN ('+ @GroupName +')
) AS p
FOR JSON PATH;';

EXEC sp_executesql @sql;