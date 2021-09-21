DECLARE @json NVARCHAR(MAX), @jsonII NVARCHAR(MAX);
SET @json = N'{
   "PurchaseOrders":[
      {
         "StockItemName":"Panzer Video Game",
         "Supplier":"7",
         "UnitPackageId":"1",
         "OuterPackageId":[
            6,
            7
         ],
         "Brand":"EA Sports",
         "LeadTimeDays":"5",
         "QuantityPerOuter":"1",
         "TaxRate":"6",
         "UnitPrice":"59.99",
         "RecommendedRetailPrice":"69.99",
         "TypicalWeightPerUnit":"0.5",
         "CountryOfManufacture":"Canada",
         "Range":"Adult",
         "OrderDate":"2018-01-01",
         "DeliveryMethod":"Post",
         "ExpectedDeliveryDate":"2018-02-02",
         "SupplierReference":"WWI2308"
      },
      {
         "StockItemName":"Panzer Video Game",
         "Supplier":"5",
         "UnitPackageId":"1",
         "OuterPackageId":"7",
         "Brand":"EA Sports",
         "LeadTimeDays":"5",
         "QuantityPerOuter":"1",
         "TaxRate":"6",
         "UnitPrice":"59.99",
         "RecommendedRetailPrice":"69.99",
         "TypicalWeightPerUnit":"0.5",
         "CountryOfManufacture":"Canada",
         "Range":"Adult",
         "OrderDate":"2018-01-025",
         "DeliveryMethod":"Post",
         "ExpectedDeliveryDate":"2018-02-02",
         "SupplierReference":"269622390"
      }
   ]
}';

SET @jsonII = 
(SELECT StockItemName, SupplierID, UnitPackageID, CONCAT(OuterPackageIDII, OuterPackageID) AS OuterPackageID,
Brand, LeadTimeDays, QuantityPerOuter, TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit,
[CustomFields.CountryOfManufacture], [CustomFields.Range]
FROM OPENJSON(@json, '$.PurchaseOrders')
WITH(
StockItemName NVARCHAR(100) '$.StockItemName',
SupplierID INT '$.Supplier',
UnitPackageID INT '$.UnitPackageId',
OuterPackageIDI NVARCHAR(MAX) '$.OuterPackageId' AS JSON,
OuterPackageIDII INT '$.OuterPackageId',
Brand NVARCHAR(50) '$.Brand',
LeadTimeDays INT '$.LeadTimeDays',
QuantityPerOuter INT '$.QuantityPerOuter',
TaxRate DECIMAL(18,2) '$.TaxRate',
UnitPrice DECIMAL(18, 2) '$.UnitPrice',
RecommendedRetailPrice DECIMAL(18, 2) '$.RecommendedRetailPrice',
TypicalWeightPerUnit DECIMAL(18, 3) '$.TypicalWeightPerUnit',
[CustomFields.CountryOfManufacture] NVARCHAR(20) '$.CountryOfManufacture',
[CustomFields.Range] NVARCHAR(20) '$.Range')
OUTER APPLY OPENJSON(OuterPackageIDI)
  WITH (OuterPackageID INT '$')
FOR JSON PATH);

BEGIN TRY
BEGIN TRAN
	INSERT INTO WideWorldImporters.Warehouse.StockItems(StockItemName, SupplierID, UnitPackageID, OuterPackageID,
Brand, LeadTimeDays, QuantityPerOuter, TaxRate, UnitPrice, RecommendedRetailPrice, TypicalWeightPerUnit, CustomFields)
	SELECT * FROM OPENJSON(@jsonII, '$')
	WITH (StockItemName NVARCHAR(100) '$.StockItemName',
	SupplierID INT '$.SupplierID',
	UnitPackageID INT '$.UnitPackageID',
	OuterPackageID INT '$.OuterPackageID',
	Brand NVARCHAR(50) '$.Brand',
	LeadTimeDays INT '$.LeadTimeDays',
	QuantityPerOuter INT '$.QuantityPerOuter',
	TaxRate DECIMAL(18,2) '$.TaxRate',
	UnitPrice DECIMAL(18, 2) '$.UnitPrice',
	RecommendedRetailPrice DECIMAL(18, 2) '$.RecommendedRetailPrice',
	TypicalWeightPerUnit DECIMAL(18, 3) '$.TypicalWeightPerUnit',
	CustomFields NVARCHAR(MAX) '$.CustomFields' AS JSON)
COMMIT TRAN;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	ROLLBACK TRAN;
END CATCH;

SELECT * FROM WideWorldImporters.Warehouse.StockItems
WHERE StockItemName = 'Panzer Video Game';