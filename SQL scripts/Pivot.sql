USE NORTHWND
GO

CREATE VIEW dbo.CustomerOrdersByYear
AS
SELECT C.CompanyName, YEAR(O.OrderDate) AS OrderYear, SUM(S.Subtotal) AS Amount
FROM Customers AS C
	JOIN Orders AS O ON C.CustomerID = O.CustomerID
	JOIN [Order Subtotals] AS S ON O.OrderID = S.OrderID
GROUP BY C.CompanyName, YEAR(O.OrderDate);
GO

SELECT *
FROM dbo.CustomerOrdersByYear
PIVOT
(
	SUM(Amount)
	FOR OrderYear IN ([1996], [1997], [1998])
) AS P;

SELECT CompanyName, ISNULL([1996], 0) AS [1996], ISNULL([1997], 0) AS [1997], ISNULL([1998], 0) AS [1998]
FROM dbo.CustomerOrdersByYear
PIVOT
(
	SUM(Amount)
	FOR OrderYear IN ([1996], [1997], [1998])
) AS P;
