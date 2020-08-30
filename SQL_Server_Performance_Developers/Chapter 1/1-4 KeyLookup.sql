USE AdventureWorks2016CTP3
SET STATISTICS IO, TIME ON

SELECT City, StateProvinceID, PostalCode
FROM Person.Address
WHERE StateProvinceID = 1;
GO

create index NCI_KeyLookupDemo on Person.Address (StateProvinceID)
include (AddressID, PostalCode, City)