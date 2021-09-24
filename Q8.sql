-- Use DATEPART function to extract month

SELECT DATEPART(MONTH, o.OrderDate) AS Month, s.StateProvinceName, AVG(DATEDIFF(DAY, o.OrderDate, i.ConfirmedDeliveryTime)) AS AvgDates FROM WideWorldImporters.Sales.Invoices i
INNER JOIN WideWorldImporters.Sales.Orders o
ON i.OrderID = o.OrderID
INNER JOIN WideWorldImporters.Sales.Customers c
ON o.CustomerID = c.CustomerID
INNER JOIN WideWorldImporters.Application.Cities city
ON c.DeliveryCityID = city.CityID
INNER JOIN WideWorldImporters.Application.StateProvinces s
ON city.StateProvinceID = s.StateProvinceID
GROUP BY DATEPART(MONTH, o.OrderDate), s.StateProvinceName
ORDER BY Month, s.StateProvinceName;