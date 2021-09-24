-- Use ISNULL function to replace NULL value with 'No Sales'
-- Use ROW_NUMBER() window function to find the most deliveries item in each city

WITH cte AS (SELECT city.CityID, s.StockItemID, SUM(ol.PickedQuantity) AS Total
FROM WideWorldImporters.Application.Cities city
LEFT JOIN WideWorldImporters.Sales.Customers c
ON city.CityID = c.DeliveryCityID
LEFT JOIN WideWorldImporters.Sales.Orders o
ON c.CustomerID = o.CustomerID
AND DATEPART(YEAR, o.OrderDate) = 2016
LEFT JOIN WideWorldImporters.Sales.OrderLines ol
ON o.OrderID = ol.OrderID
LEFT JOIN WideWorldImporters.Warehouse.StockItems s
ON ol.StockItemID = s.StockItemID
LEFT JOIN WideWorldImporters.Application.StateProvinces sp
ON city.StateProvinceID = sp.StateProvinceID
INNER JOIN WideWorldImporters.Application.Countries country
ON sp.CountryID = country.CountryID
AND country.CountryName = 'United States'
GROUP BY city.CityID, s.StockItemID
)

SELECT CityName, 
ISNULL(StockItemName, 'No Sales') AS StockItemName FROM
(SELECT city.CityName, s.StockItemName, 
ROW_NUMBER() OVER(PARTITION BY cte.CityID ORDER BY Total DESC) AS Ranking
FROM cte
LEFT JOIN WideWorldImporters.Application.Cities city
ON cte.CityID = city.CityID
LEFT JOIN WideWorldImporters.Warehouse.StockItems s
ON cte.StockItemID = s.StockItemID
) AS temp
WHERE Ranking = 1;