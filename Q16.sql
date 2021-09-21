SELECT StockItemName FROM 
(SELECT StockItemName, JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS Country
FROM WideWorldImporters.Warehouse.StockItems) AS Temp
WHERE Country = 'China';