USE eCommerce;

SELECT Prod.ProductKey
	,StockTxnDate
	,
	sum(StockOnHand) AS SOHQty
	,0 AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,0 AS SOHCost
	,0 AS LostSalesValue
	,0 AS OverStockAmount
	,0 AS OverStockCost
FROM Product prod
INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
WHERE StockOnHand > 0
	AND StockTakeFlag = 'Y'
GROUP BY prod.ProductKey
	,inv.StockTxnDate


UNION ALL

SELECT Prod.ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,sum(BackOrderQty) AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,0 AS SOHCost
	,0 AS LostSalesValue
	,0 AS OverStockAmount
	,0 AS OverStockCost
FROM Product prod
INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
WHERE BackOrderQty > 0
	AND StockTakeFlag = 'Y'
GROUP BY Prod.ProductKey
	,StockTxnDate

UNION ALL



SELECT ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,0 AS BOQQty
	,StockStatus
	,count(StockStatus) AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,0 AS SOHCost
	,0 AS LostSalesValue
	,0 AS OverStockAmount
	,0 AS OverStockCost
FROM (
	SELECT prod.ProductKey
		,StockTxnDate
		,CASE 
			WHEN StockOnHand >= prod.ReorderPoint
				THEN 'Stock Level OK'
			WHEN StockOnHand = 0
				AND BackOrderQty > 0
				THEN 'Out of Stock - Back Ordered'
			WHEN (StockOnHand < prod.ReorderPoint)
				AND BackOrderQty > 0
				THEN 'Low Stock - Back Ordered'
			WHEN BackOrderQty = 0
				AND (StockOnHand <= Prod.ReorderPoint)
				THEN 'Reorder Now'
			END AS StockStatus
	FROM Product prod
	INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
	INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
	WHERE StockOnHand > 0
		AND StockTakeFlag = 'Y'
	) AS dtStockStatus
GROUP BY ProductKey
	,StockStatus
	,StockTxnDate


UNION ALL


SELECT ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,0 AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,BackorderStatus
	,count(BackorderStatus) AS BackorderStatusCount
	,0 AS SOHCost
	,0 AS LostSalesValue
	,0 AS OverStockAmount
	,0 AS OverStockCost
FROM (
	SELECT prod.ProductKey
		,StockTxnDate
		,CASE 
			WHEN BackOrderQty > 0
				AND BackOrderQty <= 10
				THEN 'Up to 10 on order'
			WHEN BackOrderQty > 10
				AND BackOrderQty <= 20
				THEN 'Up to 20 on order'
			WHEN BackOrderQty > 20
				AND BackOrderQty <= 40
				THEN 'Up to 40 on order'
			WHEN BackOrderQty > 40
				AND BackOrderQty <= 60
				THEN 'Up to 60 on order'
			ELSE '+ 60 on order'
			END AS BackorderStatus
	FROM Product prod
	INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
	INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
	WHERE BackOrderQty > 0
		AND StockTakeFlag = 'Y'
	) AS dtBackorderstatus
GROUP BY ProductKey
	,BackorderStatus
	,StockTxnDate

UNION ALL

SELECT Prod.ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,0 AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,sum(StockOnHand * UnitCost) AS SOHCost
	,0 AS LostSalesValue
	,0 AS OverStockAmount
	,0 AS OverStockCost
FROM Product prod
INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
WHERE StockOnHand > 0
	AND StockTakeFlag = 'Y'
GROUP BY prod.productkey
	,StockTxnDate

UNION ALL


SELECT Prod.ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,0 AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,0 AS SOHCost
	,sum(BackOrderQty * ListPrice) AS LostSalesValue
	,0 AS OverStockAmount
	,0 AS OverStockCost
FROM Product prod
INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
WHERE BackOrderQty > 0
	AND StockOnHand = 0
	AND StockTakeFlag = 'Y'
GROUP BY prod.ProductKey
	,StockTxnDate


UNION ALL

SELECT Prod.ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,0 AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,0 AS SOHCost
	,0 AS LostSalesValue
	,sum(StockOnHand - MaxStockLevel) AS OverStockAmount
	,0 AS OverStockCost
FROM Product prod
INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
WHERE StockOnHand > MaxStockLevel
	AND StockTakeFlag = 'Y'
GROUP BY prod.ProductKey
	,StockTxnDate


UNION ALL

SELECT Prod.ProductKey
	,StockTxnDate
	,
	0 AS SOHQty
	,0 AS BOQQty
	,'' StockStatus
	,0 AS StockStatusCount
	,'' AS BackorderStatus
	,0 AS BackorderStatusCount
	,0 AS SOHCost
	,0 AS LostSalesValue
	,0 AS OverStockAmount
	,sum((StockOnHand - MaxStockLevel) * UnitCost) AS OverStockCost
FROM Product prod
INNER JOIN ProductInventory inv ON prod.ProductKey = inv.ProductKey
INNER JOIN ProductSubcategory psc ON prod.ProductSubcategoryKey = psc.ProductSubcategoryKey
WHERE StockOnHand > MaxStockLevel
	AND StockTakeFlag = 'Y'
GROUP BY prod.ProductKey
	,StockTxnDate