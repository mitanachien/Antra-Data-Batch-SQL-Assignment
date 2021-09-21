USE WideWorldImporters;

CREATE TABLE ods.ConfirmedDeviveryJson
(
ID INT NOT NULL IDENTITY PRIMARY KEY,
Date date,
Value NVARCHAR(MAX)
);

ALTER TABLE ods.ConfirmedDeviveryJson
ADD CONSTRAINT [Value record should be formatted as JSON] CHECK (ISJSON(Value)=1);

DROP PROCEDURE dbo.InvoiceInfoCreate;

CREATE PROCEDURE dbo.InvoiceInfoCreate
(@Date AS date, @CustomerID AS int) 
AS BEGIN
	BEGIN TRY
		DECLARE @JsonFile NVARCHAR(MAX);
		SET @JsonFile =
		(SELECT * FROM Sales.Invoices i 
		INNER JOIN Sales.InvoiceLines il
		ON i.InvoiceID = il.InvoiceID
		WHERE i.InvoiceDate = @Date
		AND i.CustomerID = @CustomerID
		FOR JSON AUTO); 
		SELECT @JsonFile;

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



SELECT * FROM ods.ConfirmedDeviveryJson;
