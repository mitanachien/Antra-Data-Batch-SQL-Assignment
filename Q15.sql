-- Use JSON_VALUE to extract values from the json type data

SELECT OrderID FROM
(SELECT DISTINCT OrderID, COUNT(JSON_VALUE(ReturnedDeliveryData, '$.Events[1].Event')) AS Num_Attempt
FROM WideWorldImporters.Sales.Invoices
GROUP BY OrderID
HAVING COUNT(JSON_VALUE(ReturnedDeliveryData, '$.Events[1].Event')) > 1) AS Temp
ORDER BY OrderID;