WITH OrderDataCTE AS
(
	SELECT [Group] AS Region, soh.CustomerID, store.Name AS Company,
		cperson.FirstName  + ' ' + cperson.LastName AS FullName,
		OrderDate, SubTotal, TaxAmt, Freight, TotalDue,
		sperson.FirstName  + ' ' + sperson.LastName AS SalesPerson
	FROM Sales.SalesOrderHeader AS soh
	INNER JOIN Sales.Customer AS cust ON soh.CustomerID = cust.CustomerID
	INNER JOIN Sales.Store AS store ON cust.StoreID = store.BusinessEntityID
	INNER JOIN Person.Person AS cperson ON cust.PersonID = cperson.BusinessEntityID
	INNER JOIN Sales.SalesPerson AS sper ON soh.SalesPersonID = sper.BusinessEntityID
	INNER JOIN Person.Person AS sperson ON sper.BusinessEntityID = sperson.BusinessEntityID
	INNER JOIN Sales.SalesTerritory AS terr ON soh.TerritoryID = terr.TerritoryID
	WHERE store.Name LIKE 'Q%'
)
SELECT Region, SalesPerson, CustomerID, Company, FullName,
	CONVERT(NVARCHAR(10), OrderDate, 101) AS OrderDate,
	SubTotal, TaxAmt, Freight, TotalDue
FROM OrderDataCTE
ORDER BY Company
