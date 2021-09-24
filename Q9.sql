-- Use two ctes to help calculate the total sold in two scenarios

WITH cte1 AS (SELECT s.StockItemName, SUM(pol.ReceivedOuters) AS TotalPurchased FROM WideWorldImporters.Warehouse.StockItems s
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrderLines pol
ON s.StockItemID = pol.StockItemID
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrders po
ON pol.PurchaseOrderID = po.PurchaseOrderID
WHERE DATEPART(YEAR, OrderDate) = 2015
GROUP BY s.StockItemName), 
cte2 AS (SELECT s.StockItemName, SUM(ol.PickedQuantity) AS TotalSold FROM WideWorldImporters.Warehouse.StockItems s
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON s.StockItemID = ol.StockItemID
INNER JOIN WideWorldImporters.Sales.Orders o
ON ol.OrderID = o.OrderID
WHERE DATEPART(YEAR, OrderDate) = 2015
GROUP BY s.StockItemName)

SELECT cte1.StockItemName FROM cte1
LEFT JOIN cte2
ON cte1.StockItemName = cte2.StockItemName
WHERE (TotalPurchased - TotalSold) > 0;
