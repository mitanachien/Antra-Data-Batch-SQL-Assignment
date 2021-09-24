USE WideWorldImporters;
GO

--DROP TABLE ods.ConfirmedDeviveryJson;

-- Create table
CREATE TABLE ods.ConfirmedDeviveryJson
(
ID INT NOT NULL IDENTITY PRIMARY KEY,
Date date,
Value NVARCHAR(MAX)
);

-- Add CHECK constraint to ensure the datatype is JSON
ALTER TABLE ods.ConfirmedDeviveryJson
ADD CONSTRAINT [Value record should be formatted as JSON] CHECK (ISJSON(Value)=1);

--DROP PROCEDURE dbo.InvoiceInfoCreate;

CREATE PROCEDURE dbo.InvoiceInfoCreate
(@Date AS date) 
AS BEGIN
	BEGIN TRY
		DECLARE @JsonFile NVARCHAR(MAX);
		SET @JsonFile =
		(SELECT * FROM Sales.Invoices i 
		INNER JOIN Sales.InvoiceLines il
		ON i.InvoiceID = il.InvoiceID
		WHERE i.InvoiceDate = @Date
		FOR JSON AUTO); 

		BEGIN TRAN;
		SAVE TRAN MySavePoint;
			INSERT INTO ods.ConfirmedDeviveryJson(Date, Value)
			VALUES(@Date, @JsonFile);
		COMMIT TRAN;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN MySavePoint;
	END CATCH
END;

-- 1 - Declare Variables
DECLARE @eachdate date

-- 2 - Declare Cursor
DECLARE MyCursor CURSOR FOR
SELECT InvoiceDate
FROM WideWorldImporters.Sales.Invoices
WHERE CustomerID = 1 

-- Open the Cursor
OPEN MyCursor

-- 3 - Fetch the next record from the cursor
FETCH NEXT FROM MyCursor INTO @eachdate

-- Set the status for the cursor
WHILE @@FETCH_STATUS = 0  
BEGIN  
	-- 4 - Begin the custom business logic
   	EXEC dbo.InvoiceInfoCreate @eachdate;

	-- 5 - Fetch the next record from the cursor
 	FETCH NEXT FROM MyCursor INTO @eachdate
END

-- 6 - Close the cursor
CLOSE MyCursor  

-- 7 - Deallocate the cursor
DEALLOCATE MyCursor 

SELECT * FROM ods.ConfirmedDeviveryJson;
