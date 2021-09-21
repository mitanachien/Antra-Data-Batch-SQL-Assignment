WITH cte1 AS (SELECT sg.StockGroupName, SUM(pol.ReceivedOuters) AS TotalPurchased 
FROM WideWorldImporters.Warehouse.StockGroups sg
INNER JOIN WideWorldImporters.Warehouse.StockItemStockGroups sisg
ON sg.StockGroupID = sisg.StockGroupID
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrderLines pol
ON sisg.StockItemID = pol.StockItemID
GROUP BY sg.StockGroupName),
cte2 AS (SELECT sg.StockGroupName, SUM(ol.PickedQuantity) AS TotalSold 
FROM WideWorldImporters.Warehouse.StockGroups sg
INNER JOIN WideWorldImporters.Warehouse.StockItemStockGroups sisg
ON sg.StockGroupID = sisg.StockGroupID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON sisg.StockItemID = ol.StockItemID
GROUP BY sg.StockGroupName),
cte3 AS (SELECT cte1.StockGroupName, (TotalPurchased-TotalSold) AS Remaining 
FROM cte1 INNER JOIN cte2
ON cte1.StockGroupName = cte2.StockGroupName)

SELECT cte1.StockGroupName, cte1.TotalPurchased, cte2.TotalSold, cte3.Remaining
FROM cte1
INNER JOIN cte2
ON cte1.StockGroupName = cte2.StockGroupName
INNER JOIN cte3
ON cte2.StockGroupName = cte3.StockGroupName;