SELECT StockItemName, COUNT(StockItemName) AS TotalQuantity FROM WideWorldImporters.Warehouse.StockItems s
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrderLines po
ON s.StockItemID = po.StockItemID
INNER JOIN WideWorldImporters.Purchasing.PurchaseOrders p
ON po.PurchaseOrderID = p.PurchaseOrderID
WHERE DATEPART(YEAR, p.OrderDate) = '2013'
GROUP BY StockItemName;