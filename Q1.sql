--Select all needed info from tow tables
SELECT p.FullName, p.PhoneNumber AS PersonalPhoneNumber, p.FaxNumber AS PersonalFaxNumber, 
c.PhoneNumber AS CompanyPhoneNumber, c.FaxNumber AS CompanyFaxNumber
FROM WideWorldImporters.Application.People p
LEFT JOIN WideWorldImporters.Sales.Customers c
ON p.PersonID = c.PrimaryContactPersonID
OR p.PersonID = c.AlternateContactPersonID;