USE WideWorldImporters;

CREATE SCHEMA ods;
GO

CREATE TABLE ods.Orders(
OrderID int NOT NULL, 
OrderDate date NOT NULL, 
OrderTotal int NOT NULL, 
CustomerID int NOT NULL
);

DROP PROCEDURE dbo.CalculateOrderTotal;

CREATE PROCEDURE dbo.CalculateOrderTotal
(@OrderDate AS date)
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		SAVE TRANSACTION MySavePoint;
		IF EXISTS (SELECT * FROM ods.Orders WHERE OrderDate = @OrderDate)
			THROW 50001, 'This date is already exist.', 1;
		ELSE
		BEGIN
		INSERT INTO ods.Orders(OrderID, OrderDate, OrderTotal, CustomerID)
		SELECT OrderID, @OrderDate AS OrderDate, OrderTotal, CustomerID
		FROM
		(SELECT o.OrderID, o.CustomerID, SUM(ol.PickedQuantity) AS OrderTotal
		FROM Sales.Orders o INNER JOIN Sales.OrderLines ol
		ON o.OrderID = ol.OrderID
		WHERE o.OrderDate = @OrderDate
		GROUP BY o.OrderID, o.CustomerID) AS Temp;
		COMMIT TRANSACTION;
		END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		BEGIN
			THROW
			ROLLBACK TRANSACTION MySavePoint;
		END
	END CATCH
END;
GO

EXEC dbo.CalculateOrderTotal '2015-01-01';
EXEC dbo.CalculateOrderTotal '2015-01-02';
EXEC dbo.CalculateOrderTotal '2015-01-03';
EXEC dbo.CalculateOrderTotal '2015-01-04';
EXEC dbo.CalculateOrderTotal '2015-01-05';
EXEC dbo.CalculateOrderTotal '2015-01-06';
EXEC dbo.CalculateOrderTotal '2015-01-07';
EXEC dbo.CalculateOrderTotal '2015-01-08';
EXEC dbo.CalculateOrderTotal '2015-01-09';
EXEC dbo.CalculateOrderTotal '2015-01-10';
EXEC dbo.CalculateOrderTotal '2015-01-11';
EXEC dbo.CalculateOrderTotal '2015-01-12';
EXEC dbo.CalculateOrderTotal '2015-01-13';
EXEC dbo.CalculateOrderTotal '2015-01-14';
EXEC dbo.CalculateOrderTotal '2015-01-15';

SELECT * FROM ods.Orders;

--DELETE FROM ods.Orders
--WHERE OrderDate = '2015-01-05';