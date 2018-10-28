SELECT C.CategoryName, STUFF(TopProducts, 1, 2, '') AS N
FROM dbo.Categories AS C
	OUTER APPLY (
		SELECT TOP(3) ', ' + P.ProductName [text()]
		FROM dbo.Products AS P
		WHERE P.CategoryID = C.CategoryID
		ORDER BY P.UnitPrice DESC
		FOR XML PATH('')
	) AS P(TopProducts)
ORDER BY C.CategoryID
