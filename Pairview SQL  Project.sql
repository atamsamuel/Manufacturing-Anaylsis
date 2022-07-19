
-- Sales

SELECT 
A.[SalesOrderID],
A.[SalesOrderDetailID],
A.[OrderQty],
A.[UnitPrice],
A. [OrderQty] * A.[UnitPrice] AS Revenue,
A.[LineTotal] * A. [OrderQty] as SalesVolu,
A.[UnitPriceDiscount] * A.[UnitPrice] as Discount,
A.OrderQty * A.LineTotal - A.OrderQty * C.StandardCost AS SALE,
C.[ProductID],
B.[CustomerID],
B.[OrderDate],
CASE WHEN B.[OnlineOrderFlag] = 1 THEN 'Online' ELSE 'Reseller' END as Sale_Channel,
B.[OnlineOrderFlag],
B.[CustomerID],
C.[Name] AS ProductName,
C.[StandardCost],
C.[StandardCost] * [OrderQty] as COG,
C.[ListPrice],
C.[DaysToManufacture],
C.[ProductModelID],
A.[OrderQty]* C.[StandardCost] AS Total_Cost,
(A.[OrderQty] * A.[UnitPrice]) - (A.[OrderQty] * C.[StandardCost]) AS Profit,
C.[ListPrice] - A.[UnitPrice] AS Price_belowListPrice,
D.[Name] AS ProductSubcategory,
E.[Name] AS ProductCategory,
B.[TerritoryID]

FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Sales].[SalesOrderHeader] B
ON A.SalesOrderID = B.SalesOrderID
left JOIN [Production].[Product] C
ON A.ProductID = C.ProductID
left JOIN [Production].[ProductSubcategory] D
ON C.ProductSubcategoryID = D.ProductSubcategoryID
inner JOIN [Production].[ProductCategory] E
ON E.ProductCategoryID = D.ProductCategoryID




SELECT [UnitPriceDiscount],[UnitPrice]*[UnitPriceDiscount]
FROM [Sales].[SalesOrderDetail]

SELECT
A.WorkOrderID,
A.OrderQty,
A.ProductID,
A.StockedQty,
A.ScrappedQty,
D.[ProductModelID],
C.ProductID,
A.StartDate,
B.Name AS Scrap_Reason,
C.Name AS Product_Name,
D.Name as Model_Name

FROM [Production].[WorkOrder] A
 LEFT JOIN  [Production].[ScrapReason] B
ON A.ScrapReasonID = B.ScrapReasonID
LEFT JOIN [Production].[Product] C
ON A.ProductID = C.ProductID
LEFT JOIN [Production].[ProductModel] D
ON C.ProductModelID = D.ProductModelID







SELECT B.[OrderQty], B.[ScrappedQty],A.[SalesOrderID]
FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Production].[WorkOrder] B
ON A.[ProductID] = B.[ProductID]


--Manufacturing
select A.[WorkOrderID],
A.[ProductID],
A.[OrderQty],
A.[StockedQty],
A.[ScrappedQty],
C.[ActualCost],
C.[ActualStartDate],
C.[PlannedCost],
C.PlannedCost AS BUDJET,
C.[ActualEndDate],
C.[ScheduledStartDate],
C.[ScheduledEndDate],
B.[Name] AS Scrappreason,
D.Name AS Product_name,
E.Name AS Model_Name,
F.Name as Product_SubCatName,
J.Name AS ProductCatName,
C.LocationID,
CASE
WHEN C.[ActualEndDate] > C.[ScheduledEndDate] THEN DATEDIFF(DAY,C.[ScheduledEndDate],C.[ActualEndDate])
WHEN C.[ActualStartDate] > C.[ScheduledStartDate] THEN DATEDIFF(DAY,C.[ScheduledEndDate],C.[ActualEndDate])
ELSE Null end Time_difference


from [Production].[WorkOrder] A
LEFT JOIN [Production].[ScrapReason] B
ON A.[ScrapReasonID] = B. [ScrapReasonID]
LEFT JOIN [Production].[WorkOrderRouting] C
ON A.[WorkOrderID] = C.[WorkOrderID]
LEFT JOIN [Production].[Product] D
ON D.[ProductID] = A.[ProductID]
LEFT JOIN [Production].[ProductModel] E
ON D.[ProductModelID] = E.[ProductModelID]
LEFT JOIN [Production].[ProductSubcategory] F
ON D.[ProductSubcategoryID] = F.[ProductSubcategoryID]
left join [Production].[ProductCategory] J
ON F.ProductCategoryID = J.ProductCategoryID




-- Customer Table
 SELECT
A.[CustomerID]
,A.OnlineOrderFlag
,A.[OrderDate],
A.[SalesOrderID],
A.[ModifiedDate]
,B.*,
CASE WHEN B.[HouseOwnerFlag] = 1 THEN 'Yes' ELSE 'No' END as House_Owner
FROM [Sales].[SalesOrderHeader] AS A
left JOIN [AdventureWorksDW2017].[dbo].[DimCustomer] AS B
ON A.CustomerID = B.[CustomerKey]
Where A.OnlineOrderFlag = 1


-- Location 
SELECT  A.[TerritoryID],
A.[CountryRegionCode],
A.[Name] AS Country,
A.[Group] AS Region,
B.[Name] AS State,
C.[SalesOrderID],
[CustomerID],
[SalesPersonID]
from [Sales].[SalesTerritory] A 
 JOIN [Person].[StateProvince] B
ON A.[TerritoryID] = B.[TerritoryID]
inner JOIN [Sales].[SalesOrderHeader] C
ON A.TerritoryID = C.TerritoryID

select [TerritoryID],
[Name] AS Country,
[CountryRegionCode],
[Group] AS Continent
from[Sales].[SalesTerritory]



/**SELECT
A.[SalesOrderID]
,max(CASE WHEN B.[Name] = 'Price' THEN 1 ELSE 0 END) AS SalesReason_Price
,max(CASE WHEN B.[Name] = 'Quality' THEN 1 ELSE 0 END) AS SalesReason_Quality
,max(CASE WHEN B.[Name] = 'Review' THEN 1 ELSE 0 END) AS SalesReason_Review
,Max(CASE WHEN B.[Name] = 'Other' THEN 1 ELSE 0 END) AS SalesReason_Other
,max(CASE WHEN B.[Name] = 'Television  Advertisement' THEN 1 ELSE 0 END) AS SalesReason_TV
,max(CASE WHEN B.[Name] = 'Manufacturer' THEN 1 ELSE 0 END) AS SalesReason_Manufacturer
,max(CASE WHEN B.[Name] = 'On Promotion' THEN 1 ELSE 0 END) AS SalesReason_Promotion
FROM [Sales].[SalesOrderHeaderSalesReason] AS A
LEFT JOIN [Sales].[SalesReason] AS B
ON A.SalesReasonID = B.SalesReasonID
group by A.[SalesOrderID]
order by A.[SalesOrderID]*/



select a.[Name] As Category, b.Name as Accessories, c.Name  AS ProductName from  [Production].[ProductCategory] a
join [Production].[ProductSubcategory]  b
on a.ProductCategoryID = b.ProductCategoryID
join [Production].[Product] c
on b.ProductSubcategoryID = c.ProductSubcategoryID


--MBA
SELECT item, AVG(Avg_Price) AS Avg_Price,
AVG(Monthly_Volume) As Monthly_Volume
FROM
(
SELECT c.[Name] as item ,
FORMAT(D.[OrderDate], 'yyyy-MM') AS Year_month,
AVG(A.[UnitPrice]) AS Avg_Price
,SUM ([OrderQty]) AS Monthly_Volume
FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Production].[Product] B
ON A.[ProductID] = B.ProductID
LEFT JOIN [Production].[ProductModel] C
ON B.ProductModelID = C.ProductModelID
LEFT JOIN [Sales].[SalesOrderHeader] D
ON A.SalesOrderID = D.SalesOrderID
WHERE [OnlineOrderFlag] = 1
GROUP BY C.Name,
FORMAT (D.[OrderDate], 'yyyy-MM')) AS A


GROUP BY item
order by item


SELECT A.SalesOrderID AS 'TransationID ',
C.Name AS Item
FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Production].[Product] B
ON A.[ProductID] = B.ProductID
LEFT JOIN [Production].[ProductModel] C
ON B.ProductModelID = C.ProductModelID
LEFT JOIN [Sales].[SalesOrderHeader] D
ON A.SalesOrderID = D.SalesOrderID
WHERE [OnlineOrderFlag] = 1
ORDER BY A.SalesOrderID



SELECT C.Name AS ProductName,
MAX ([UnitPrice]) as MaxPrice,
MIN ([UnitPrice]) AS MIN_Price,
AVG ([UnitPrice]) AS AVG_Price


FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Production].[Product] B
ON A.ProductID = B.ProductID
LEFT JOIN [Production].[ProductSubcategory] C
ON B.ProductSubcategoryID = C.ProductSubcategoryID
left join [Sales].[SalesOrderHeader] D
on A.SalesOrderID = D.SalesOrderID

GROUP BY C.Name 


SELECT
FORMAT (b.[OrderDate], 'yyyy-MM') AS Year_month,
A.[UnitPrice],
A. [OrderQty] * A.[UnitPrice] AS Revenue,
CASE WHEN B.[OnlineOrderFlag] = 1 THEN 'Online' ELSE 'Reseller' END as Sale_Channel,
B.[OnlineOrderFlag],
C.Name as country,
C.[Group] as Continent
FROM [Sales].[SalesOrderDetail] A
LEFT JOIN [Sales].[SalesOrderHeader] B
ON A.SalesOrderID = B.SalesOrderID
left join [Sales].[SalesTerritory] C
on b.TerritoryID = c.TerritoryID
where [OnlineOrderFlag] =  1 and c.Name = 'Australia'




select A.ShipMethodID,
A.OrderDate, B.DueDate, 
A.OrderDate - B.DueDate 
from[Purchasing].[PurchaseOrderHeader] A
left join [Purchasing].[PurchaseOrderDetail] B
on a.PurchaseOrderID = b.PurchaseOrderID


 




 SELECT DISTINCT A.[PurchaseOrderID],
E.Name as Vendor, A.OrderDate,
E.BusinessEntityID, A.ShipMethodID,
B.Name AS Ship_Mode,

A.ShipDate, B.ShipRate, C.DueDate,
DATEDIFF (DAY,  a.OrderDate,C.DueDate) AS Delayed,
CASE

WHEN DATEDIFF(DAY, c.DueDate, a.OrderDate) < = 1 THEN 'ONTIME'
WHEN  DATEDIFF(DAY, C.DueDate, a.OrderDate) < = 4 THEN '2 TO 4 DAYS'
WHEN  DATEDIFF(DAY, C.DueDate,a.OrderDate) < = 8 THEN '5 TO 8 DAYS'
WHEN  DATEDIFF(DAY, C.DueDate, a.OrderDate) < = 15 THEN '9 TO 15 DAYS'
ELSE '+15days' END as [late Delivery],
C.ReceivedQty, 
C.RejectedQty,
D.AverageLeadTime

FROM [Purchasing].[PurchaseOrderHeader] A
 LEFT JOIN [Purchasing].[ShipMethod] B
 ON A.ShipMethodID = B.ShipMethodID
 left join [Purchasing].[PurchaseOrderDetail] C
 ON A.PurchaseOrderID = C.PurchaseOrderID
 left join [Purchasing].[ProductVendor] D
 on c.ProductID = d.ProductID
 left join [Purchasing].[Vendor] E
 on d.BusinessEntityID = e.BusinessEntityID



 --Shipping
 
SELECT DISTINCT A.[PurchaseOrderID],
E.Name as Vendor, 
A.OrderDate, 
E.BusinessEntityID,
A.ShipMethodID,
B.Name AS Ship_Mode,
B.ShipBase,
A.ShipDate, B.ShipRate, 
C.DueDate,
 C.DueDate - A.ShipDate  AS dAYS_TO_shIP,
C.ReceivedQty, 
C.RejectedQty, 
D.AverageLeadTime

FROM [Purchasing].[PurchaseOrderHeader] A
 LEFT JOIN [Purchasing].[ShipMethod] B
 ON A.ShipMethodID = B.ShipMethodID
 left join [Purchasing].[PurchaseOrderDetail] C
 ON A.PurchaseOrderID = C.PurchaseOrderID
 left join [Purchasing].[ProductVendor] D
 on c.ProductID = d.ProductID
 left join [Purchasing].[Vendor] E
 on d.BusinessEntityID = e.BusinessEntityID


 --Shipping
 SELECT A.[PurchaseOrderID],
E.Name as Vendor, 
A.OrderDate, 
E.BusinessEntityID,
A.ShipMethodID,
B.Name AS Ship_Mode,
B.ShipBase,
CASE WHEN E.[ActiveFlag] = 1 THEN 'ACTIVE_VENDORS' ELSE 'NON_ACTIVE_VENDORS' END AS Vendor_Status,

A.ShipDate, 
B.ShipRate,
C.DueDate,
DATEDIFF (DAY, A.ShipDate, C.DueDate) AS dAYS_TO_shIP,
C.ReceivedQty, 
C.RejectedQty, 
D.AverageLeadTime

FROM [Purchasing].[PurchaseOrderHeader] A
 LEFT JOIN [Purchasing].[ShipMethod] B
 ON A.ShipMethodID = B.ShipMethodID
 left join [Purchasing].[PurchaseOrderDetail] C
 ON A.PurchaseOrderID = C.PurchaseOrderID
 left join [Purchasing].[ProductVendor] D
 on c.ProductID = d.ProductID
 left join [Purchasing].[Vendor] E
 on d.BusinessEntityID = e.BusinessEntityID



 --Manufacturing Load...)

 SELECT A.WorkOrderID, 
 A.ProductID,
 A.OrderQty,
 A.ScrappedQty,
 A.StartDate,
 B.Name AS ScrapReason,
 C.LocationID,C.[ActualEndDate] as  Expected_STARTDate,
 C.ActualCost AS Actual_Cost, c.PlannedCost as Budget_Cost,
 C.[ScheduledEndDate] AS Expected_EndDate,
 CASE
WHEN C.[ActualEndDate] > C.[ScheduledEndDate] THEN DATEDIFF(DAY,C.[ScheduledEndDate],C.[ActualEndDate])
WHEN C.[ActualStartDate] > C.[ScheduledStartDate] THEN DATEDIFF(DAY,C.[ScheduledStartDate],C.[ActualStartDate])
ELSE Null end Time_difference,
D.CostRate,
D.Name Location_NAME,
C.ActualCost - C.PlannedCost AS Exceed_Budget,
E.Name as Product_Name

 FROM [Production].[WorkOrder] A
 LEFT JOIN [Production].[ScrapReason] B
 ON A.ScrapReasonID = B.ScrapReasonID
 LEFT JOIN [Production].[WorkOrderRouting] C
 ON A.WorkOrderID =C.WorkOrderID
 left JOIN [Production].[Location] D
 ON C.LocationID = D.LocationID
 left Join [Production].[Product] E
 ON a.ProductID = e.ProductID
 


 Select
 PWO.[WorkOrderID]
 ,PWO.[ProductID]
 ,PWO.[OrderQty]
 ,PWO.[StockedQty]
 ,PWO.[ScrappedQty]
 ,PWO.[ScrappedQty]/PWO.[OrderQty] AS '%ScrappedQty'
 ,PWOR.[ActualCost] AS ACTUAL_COST
,PWOR.[PlannedCost] AS Budget_Cost
,PWOR.[ScheduledStartDate] AS Expected_ManStartDate
,PWOR.[ScheduledEndDate] AS Expected_ManEndDate
,PWOR.[ActualStartDate] AS Man_Start_Date
,PWOR.[ActualEndDate] AS Man_End_Date
,CASE WHEN [ActualStartDate] > [ScheduledStartDate] THEN DATEDIFF(DAY,PWOR. [ScheduledStartDate],[ActualStartDate])
 WHEN [ActualEndDate] > [ScheduledEndDate] THEN DATEDIFF (DAY,PWOR. [ScheduledEndDate],[ActualEndDate])
 ELSE NULL end Time_DIFF
,PL.[LocationID]
,PL.[Name] AS LOCATION_NAME
,PL.[CostRate]
 ,PSR.[Name] AS Scrap_Reason
 ,PP.[Name] AS Product_Name
 ,PPM.[Name] AS Model_Name
 ,PSC.[Name] AS ProductSubCate_Name
 ,PC.[Name] AS ProductCate_Name
 From [Production].[WorkOrder] AS PWO
 LEFT JOIN [Production].[ScrapReason] AS PSR
 ON PWO.[ScrapReasonID] = PSR.[ScrapReasonID]
 LEFT JOIN [Production].[WorkOrderRouting] AS PWOR
 ON PWO.[WorkOrderID] = PWOR.[WorkOrderID]
 LEFT JOIN [Production].[Location] AS PL
 ON PWOR.[LocationID] = PL.[LocationID]
 LEFT JOIN [Production].[Product] AS PP
ON PP.[ProductID] = PWO.[ProductID]
 LEFT JOIN [Production].[ProductModel] AS PPM
 ON PP.[ProductModelID] = PPM. [ProductModelID]
 LEFT JOIN [Production].[ProductSubcategory] AS PSC
 ON PP.[ProductSubcategoryID] = PSC.[ProductSubcategoryID]
 LEFT JOIN [Production].[ProductCategory] AS PC
 ON PSC.[ProductCategoryID] = PC.[ProductCategoryID]
 LEFT JOIN [Purchasing].[ProductVendor] AS PPV
 ON PP.[ProductID]= PPV.[ProductID]


 SELECT
PPV.[AverageLeadTime] AS Average_Delivery_Days
,PPV.[BusinessEntityID]
,PV.[Name] AS Vendors
,CASE WHEN PV.[ActiveFlag] = 1 THEN 'ACTIVE_VENDORS' ELSE 'NON_ACTIVE_VENDORS' END AS Vendor_Status
,PV.[ActiveFlag]
,PPOD.[ProductID]
,PPOD.[OrderQty]
,PPOD.[DueDate]
,PPOD.[RejectedQty] AS QuantityRejectedFromVendors
,PPOD.[ReceivedQty] AS QuantityReceivedFromVendors
FROM [Purchasing].[PurchaseOrderDetail] AS PPOD
LEFT JOIN [Purchasing].[ProductVendor] AS PPV
ON PPOD.[ProductID] = PPV.[ProductID]
LEFT JOIN [Purchasing].[Vendor] AS PV
ON PPV.[BusinessEntityID] = PV.[BusinessEntityID]


------SUPPLY CHAIN 2-----
SELECT
PPOH.[PurchaseOrderID]
,PPOH.[VendorID] AS VENDOR_ID
,PPOH.[OrderDate] AS Order_Date
,PPOH.[ShipDate]
,PSM.[ShipMethodID]
,PSM.[Name] AS SHIP_MODE
,PSM.[ShipBase]
,PSM.[ShipRate]
FROM [Purchasing].[PurchaseOrderHeader] AS PPOH
LEFT JOIN [Purchasing].[ShipMethod] AS PSM
ON PPOH.[ShipMethodID] = PSM.[ShipMethodID]



select 