USE WideWorldImporters;

DROP TABLE ods.StockItem;

SELECT [StockItemID], 
[StockItemName],
[SupplierID],
[ColorID],
[UnitPackageID],
[OuterPackageID],
[Brand],
[Size],
[LeadTimeDays],
[QuantityPerOuter],
[IsChillerStock],
[Barcode],
[TaxRate],
[UnitPrice],
[RecommendedRetailPrice],
[TypicalWeightPerUnit],
[MarketingComments],
[InternalComments], 
JSON_VALUE([CustomFields], '$.CountryOfManufacture') AS CountryOfManufacture,
JSON_VALUE([CustomFields], '$.Range') AS Range, 
JSON_VALUE([CustomFields], '$.Shelflife') AS Shelflife
INTO ods.StockItem FROM Warehouse.StockItems;

SELECT * FROM ods.StockItem;