SELECT s.StockItemName, CONCAT(c.DeliveryAddressLine1, c.DeliveryAddressLine2) AS DeliveryAddress, 
state.StateProvinceName, city.CityName, country.CountryName, c.CustomerName, p.FullName, c.PhoneNumber,
ol.PickedQuantity
FROM WideWorldImporters.Sales.Orders o
INNER JOIN WideWorldImporters.Sales.Customers c
ON o.CustomerID = c.CustomerID
INNER JOIN WideWorldImporters.Application.People p
ON c.PrimaryContactPersonID = p.PersonID
INNER JOIN WideWorldImporters.Sales.OrderLines ol
ON o.OrderID = ol.OrderID
INNER JOIN WideWorldImporters.Warehouse.StockItems s
ON ol.StockItemID = s.StockItemID
INNER JOIN WideWorldImporters.Application.Cities city
ON c.DeliveryCityID = city.CityID
INNER JOIN WideWorldImporters.Application.StateProvinces state
ON city.StateProvinceID = state.StateProvinceID
INNER JOIN WideWorldImporters.Application.Countries country
ON state.CountryID = country.CountryID
WHERE o.OrderDate = '2014-07-01';
