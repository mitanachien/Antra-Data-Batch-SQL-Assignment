USE WideWorldImporters;

DROP PROCEDURE dbo.OrderInNextSevenDays;

CREATE PROCEDURE dbo.OrderInNextSevenDays
(@OrderDate AS date)
AS BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;
		SAVE TRANSACTION MySavePoint;
		IF EXISTS (SELECT * FROM ods.Orders WHERE OrderDate < @OrderDate)
		BEGIN
			DELETE FROM ods.Orders
			WHERE OrderDate < @OrderDate;
		END
		SELECT * FROM ods.Orders
		WHERE OrderDate >= @OrderDate
		AND OrderDate < DATEADD(DAY, 7, @OrderDate);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION MySavePoint;
	END CATCH
END;
GO

SELECT * FROM ods.Orders;

EXEC dbo.OrderInNextSevenDays '2015-01-02';

SELECT * FROM ods.Orders;