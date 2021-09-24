-- Use LEN function to calculate string length
SELECT StockItemName FROM WideWorldImporters.Warehouse.StockItems
WHERE LEN(MarketingComments) > 10;