-- Use DATEDIFF function to calculate the difference of two dates
-- Use GROUP BY to calculate average dates

SELECT s.StateProvinceName, AVG(DATEDIFF(DAY, o.OrderDate, i.ConfirmedDeliveryTime)) AS AverageDays FROM WideWorldImporters.Sales.Invoices i
INNER JOIN WideWorldImporters.Sales.Orders o
ON i.OrderID = o.OrderID
INNER JOIN WideWorldImporters.Sales.Customers c
ON o.CustomerID = c.CustomerID
INNER JOIN WideWorldImporters.Application.Cities city
ON c.DeliveryCityID = city.CityID
INNER JOIN WideWorldImporters.Application.StateProvinces s
ON city.StateProvinceID = s.StateProvinceID
GROUP BY s.StateProvinceName;
