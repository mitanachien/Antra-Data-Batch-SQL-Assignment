SELECT CustomerName FROM WideWorldImporters.Application.People p
INNER JOIN WideWorldImporters.Sales.Customers c
ON p.PersonID = c.PrimaryContactPersonID
WHERE p.PhoneNumber = c.PhoneNumber;