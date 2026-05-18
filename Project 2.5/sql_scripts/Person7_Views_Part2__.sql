USE [PrestigeCars]
GO

PRINT '========================================================'
PRINT 'Person 7 - Views Part 2 Starting...'
PRINT 'Dropping old tables and creating views'
PRINT '========================================================'
GO

IF OBJECT_ID('Reference.SalesCategory', 'U') IS NOT NULL
BEGIN
    DROP TABLE [Reference].[SalesCategory]
    PRINT 'Dropped table Reference.SalesCategory'
END
GO

IF OBJECT_ID('Reference.SalesCategory', 'V') IS NOT NULL
    DROP VIEW [Reference].[SalesCategory]
GO

CREATE VIEW [Reference].[SalesCategory]
AS
    SELECT SD.SalesDetailsID, SD.SalesID, SD.StockID, SD.SalePrice,       
        CASE
            WHEN SD.SalePrice < 10000                            THEN 'Under 10K'
            WHEN SD.SalePrice >= 10000 AND SD.SalePrice < 25000 THEN '10K - 25K'
            WHEN SD.SalePrice >= 25000 AND SD.SalePrice < 50000 THEN '25K - 50K'
            WHEN SD.SalePrice >= 50000 AND SD.SalePrice < 75000 THEN '50K - 75K'
            WHEN SD.SalePrice >= 75000                          THEN 'Over 75K'
            ELSE 'Unknown'   --if SalePrice is null
        END AS SaleCategory

    FROM [Data].[SalesDetails] AS SD  
GO

PRINT 'Created view Reference.SalesCategory'
GO



IF OBJECT_ID('Reference.StaffHierarchy', 'U') IS NOT NULL
BEGIN
    DROP TABLE [Reference].[StaffHierarchy]
    PRINT 'Dropped table Reference.StaffHierarchy'
END
GO

IF OBJECT_ID('Reference.StaffHierarchy', 'V') IS NOT NULL
    DROP VIEW [Reference].[StaffHierarchy]
GO

CREATE VIEW [Reference].[StaffHierarchy]
AS
    
    WITH StaffCTE AS
    (
        SELECT ST.StaffID, ST.StaffName, ST.Department, ST.ManagerID,
            CAST(ST.StaffName AS nvarchar(500)) AS HierarchyPath,
            0 AS HierarchyLevel

        FROM [Reference].[Staff] AS ST
        WHERE ST.ManagerID IS NULL  

        UNION ALL 
        SELECT
            ST.StaffID, ST.StaffName, ST.Department, ST.ManagerID,
            CAST(CTE.HierarchyPath + ' > ' + ST.StaffName AS nvarchar(500)),
            CTE.HierarchyLevel + 1

        FROM [Reference].[Staff] AS ST
        INNER JOIN StaffCTE AS CTE
            ON ST.ManagerID = CTE.StaffID  -- match employee to their manager
    )
    SELECT StaffID, StaffName, Department, ManagerID, HierarchyPath,  
        HierarchyLevel   -- 0 is top, 1 is one below, etc.
    FROM StaffCTE
GO

PRINT 'Created view Reference.StaffHierarchy'
GO

IF OBJECT_ID('Reference.YearlySales', 'U') IS NOT NULL
BEGIN
    DROP TABLE [Reference].[YearlySales]
    PRINT 'Dropped table Reference.YearlySales'
END
GO

IF OBJECT_ID('Reference.YearlySales', 'V') IS NOT NULL
    DROP VIEW [Reference].[YearlySales]
GO

CREATE VIEW [Reference].[YearlySales]
AS
    SELECT
       
        YEAR(SA.SaleDate)               AS SaleYear,
  
        COUNT(DISTINCT SA.SalesID)      AS TotalSales,
        COUNT(SD.SalesDetailsID)        AS TotalLineItems,
        SUM(SA.TotalSalePrice)          AS TotalRevenue,
        AVG(SA.TotalSalePrice)          AS AverageSalePrice,
        MIN(SA.TotalSalePrice)          AS MinSalePrice,
        MAX(SA.TotalSalePrice)          AS MaxSalePrice

    FROM [Data].[Sales] AS SA
    LEFT JOIN [Data].[SalesDetails] AS SD
        ON SA.SalesID = SD.SalesID
    GROUP BY YEAR(SA.SaleDate)
GO

PRINT 'Created view Reference.YearlySales'
GO

IF OBJECT_ID('SourceData.SalesInPounds', 'U') IS NOT NULL
BEGIN
    DROP TABLE [SourceData].[SalesInPounds]
    PRINT 'Dropped table SourceData.SalesInPounds'
END
GO

IF OBJECT_ID('SourceData.SalesInPounds', 'V') IS NOT NULL
    DROP VIEW [SourceData].[SalesInPounds]
GO

CREATE VIEW [SourceData].[SalesInPounds]
AS
    SELECT SA.SalesID, SA.SaleDate, SA.InvoiceNumber, CU.CustomerName, CN.CountryName,
        SA.TotalSalePrice   AS SalePriceOriginal, SA.TotalSalePrice   AS SalePriceGBP

    FROM [Data].[Sales] AS SA
    INNER JOIN [Data].[Customer] AS CU
        ON SA.CustomerID = CU.CustomerID
    INNER JOIN [Data].[Country] AS CN
        ON CU.CountryId = CN.CountryId
GO

PRINT 'Created view SourceData.SalesInPounds'
GO

IF OBJECT_ID('SourceData.SalesText', 'U') IS NOT NULL
BEGIN
    DROP TABLE [SourceData].[SalesText]
    PRINT 'Dropped table SourceData.SalesText'
END
GO

IF OBJECT_ID('SourceData.SalesText', 'V') IS NOT NULL
    DROP VIEW [SourceData].[SalesText]
GO

CREATE VIEW [SourceData].[SalesText]
AS
    SELECT SA.SalesID, SA.InvoiceNumber, SA.SaleDate,CU.CustomerName,
        MK.MakeName,       
        MD.ModelName,      
        ST.Color,          
        SD.SalePrice,
        SD.LineItemDiscount,
        CONCAT(
            'Invoice ', SA.InvoiceNumber,
            ' dated ', FORMAT(SA.SaleDate, 'dd MMM yyyy'),
            ': ', CU.CustomerName,
            ' purchased a ', ST.Color, ' ', MK.MakeName, ' ', MD.ModelName,
            ' for ', FORMAT(SD.SalePrice, 'C', 'en-GB'),
            CASE
                WHEN SD.LineItemDiscount > 0
                THEN CONCAT(' with a discount of ', FORMAT(SD.LineItemDiscount, 'C', 'en-GB'))
                ELSE ''
            END,

            '.'  
        ) AS SaleDescription

    FROM [Data].[Sales] AS SA

    INNER JOIN [Data].[Customer] AS CU
        ON SA.CustomerID = CU.CustomerID
    INNER JOIN [Data].[SalesDetails] AS SD
        ON SA.SalesID = SD.SalesID
    INNER JOIN [Data].[Stock] AS ST
        ON SD.StockID = ST.StockCode

    LEFT JOIN [Data].[Model] AS MD
        ON ST.ModelID = MD.ModelID
    LEFT JOIN [Data].[Make] AS MK
        ON MD.MakeID = MK.MakeID
GO

PRINT 'Created view SourceData.SalesText'
GO


PRINT '--- Reference.SalesCategory (top 5 rows) ---'
SELECT TOP 5 SalesDetailsID, SalePrice, SaleCategory
FROM [Reference].[SalesCategory]
ORDER BY SalesDetailsID
GO


PRINT '--- Reference.Staff (top 5 rows) ---'
SELECT TOP 5 StaffID, StaffName, ManagerID, Department
FROM [Reference].[Staff]
ORDER BY StaffID
GO


PRINT '--- Reference.StaffHierarchy (all rows) ---'
SELECT StaffID,  StaffName,  HierarchyLevel, HierarchyPath
FROM [Reference].[StaffHierarchy]
ORDER BY HierarchyLevel, StaffName
GO

PRINT '--- Reference.YearlySales (all rows) ---'
SELECT SaleYear, TotalSales, TotalRevenue
FROM [Reference].[YearlySales]
ORDER BY SaleYear
GO


PRINT '--- SourceData.SalesInPounds (top 5 rows) ---'
SELECT TOP 5  SalesID, CustomerName, CountryName, SalePriceOriginal, SalePriceGBP
FROM [SourceData].[SalesInPounds]
ORDER BY SalesID
GO


PRINT '--- SourceData.SalesText (top 3 rows) ---'
SELECT TOP 3 SalesID, SaleDescription
FROM [SourceData].[SalesText]
ORDER BY SalesID
GO


PRINT '--- Checking all views exist in the database ---'
SELECT SCHEMA_NAME(schema_id)  AS SchemaName, name AS ViewName, create_date, modify_date
FROM sys.objects
WHERE type = 'V'
  AND SCHEMA_NAME(schema_id) IN ('Reference', 'SourceData')
ORDER BY SchemaName, name
GO
