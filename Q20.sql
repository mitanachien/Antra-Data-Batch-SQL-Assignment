-- Create function and apply it to the OrderID column

USE WideWorldImporters;
GO

CREATE FUNCTION totalOrder (@orderIDpara INT)
RETURNS INT AS BEGIN
RETURN (
SELECT SUM(il.Quantity)
FROM WideWorldImporters.Sales.Invoices i
INNER JOIN WideWorldImporters.Sales.InvoiceLines il
ON i.InvoiceID = il.InvoiceID
WHERE i.OrderID = @orderIDpara)
END;

SELECT InvoiceID, OrderID, dbo.totalOrder(OrderID) AS OrderTotal
FROM WideWorldImporters.Sales.Invoices;