SELECT AP.EmailAddress, SI.InvoiceDate
FROM [Sales].[Invoices] SI
  INNER JOIN [Application].[People] AP ON SI.LastEditedBy = AP.PersonID
WHERE AP.EmailAddress = 'alicaf@wideworldimporters.com'

USE [WideWorldImporters]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [Sales].[Invoices] ([LastEditedBy])
INCLUDE ([InvoiceDate])
GO

USE [WideWorldImporters]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [Application].[People] ([EmailAddress])
