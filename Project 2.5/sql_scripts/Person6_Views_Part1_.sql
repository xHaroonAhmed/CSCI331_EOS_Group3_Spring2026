USE [PrestigeCars]
GO 

PRINT '========================================================'
PRINT 'Person 6 - Views Part 1 Starting...'
PRINT '========================================================'
GO

IF OBJECT_ID('[DataTransfer].[Sales2015]', 'U') IS NOT NULL DROP TABLE [DataTransfer].[Sales2015];
IF OBJECT_ID('[DataTransfer].[Sales2015]', 'V') IS NOT NULL DROP VIEW [DataTransfer].[Sales2015];
GO

CREATE VIEW [DataTransfer].[Sales2015] AS
SELECT 
    mk.MakeName,
    m.ModelName,
    c.CustomerName,
    co.CountryName,
    st.Cost,
    st.RepairsCost,
    sd.SalePrice,
    s.SaleDate 
FROM [Data].[Sales] s  
INNER JOIN [Data].[SalesDetails] sd ON s.SalesID = sd.SalesID
INNER JOIN [Data].[Customer] c ON s.CustomerID = c.CustomerID
LEFT JOIN [Data].[Country] co ON c.CountryId = co.CountryId
INNER JOIN [Data].[Stock] st ON sd.StockID = st.StockCode
INNER JOIN [Data].[Model] m ON st.ModelID = m.ModelID
INNER JOIN [Data].[Make] mk ON m.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2015
GO

PRINT 'Created view DataTransfer.Sales2015'
GO

IF OBJECT_ID('[DataTransfer].[Sales2016]', 'U') IS NOT NULL DROP TABLE [DataTransfer].[Sales2016];
IF OBJECT_ID('[DataTransfer].[Sales2016]', 'V') IS NOT NULL DROP VIEW [DataTransfer].[Sales2016];
GO

CREATE VIEW [DataTransfer].[Sales2016] AS
SELECT 
    mk.MakeName,
    m.ModelName,
    c.CustomerName,
    co.CountryName,
    st.Cost,
    st.RepairsCost,
    sd.SalePrice,
    s.SaleDate 
FROM [Data].[Sales] s  
INNER JOIN [Data].[SalesDetails] sd ON s.SalesID = sd.SalesID
INNER JOIN [Data].[Customer] c ON s.CustomerID = c.CustomerID
LEFT JOIN [Data].[Country] co ON c.CountryId = co.CountryId
INNER JOIN [Data].[Stock] st ON sd.StockID = st.StockCode
INNER JOIN [Data].[Model] m ON st.ModelID = m.ModelID
INNER JOIN [Data].[Make] mk ON m.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2016
GO

PRINT 'Created view DataTransfer.Sales2016'
GO

IF OBJECT_ID('[DataTransfer].[Sales2017]', 'U') IS NOT NULL DROP TABLE [DataTransfer].[Sales2017];
IF OBJECT_ID('[DataTransfer].[Sales2017]', 'V') IS NOT NULL DROP VIEW [DataTransfer].[Sales2017];
GO

CREATE VIEW [DataTransfer].[Sales2017] AS
SELECT 
    mk.MakeName,
    m.ModelName,
    c.CustomerName,
    co.CountryName,
    st.Cost,
    st.RepairsCost,
    sd.SalePrice,
    s.SaleDate 
FROM [Data].[Sales] s  
INNER JOIN [Data].[SalesDetails] sd ON s.SalesID = sd.SalesID
INNER JOIN [Data].[Customer] c ON s.CustomerID = c.CustomerID
LEFT JOIN [Data].[Country] co ON c.CountryId = co.CountryId
INNER JOIN [Data].[Stock] st ON sd.StockID = st.StockCode
INNER JOIN [Data].[Model] m ON st.ModelID = m.ModelID
INNER JOIN [Data].[Make] mk ON m.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2017
GO

PRINT 'Created view DataTransfer.Sales2017'
GO

IF OBJECT_ID('[DataTransfer].[Sales2018]', 'U') IS NOT NULL DROP TABLE [DataTransfer].[Sales2018];
IF OBJECT_ID('[DataTransfer].[Sales2018]', 'V') IS NOT NULL DROP VIEW [DataTransfer].[Sales2018];
GO

CREATE VIEW [DataTransfer].[Sales2018] AS
SELECT 
    mk.MakeName,
    m.ModelName,
    c.CustomerName,
    co.CountryName,
    st.Cost,
    st.RepairsCost,
    sd.SalePrice,
    s.SaleDate 
FROM [Data].[Sales] s  
INNER JOIN [Data].[SalesDetails] sd ON s.SalesID = sd.SalesID
INNER JOIN [Data].[Customer] c ON s.CustomerID = c.CustomerID
LEFT JOIN [Data].[Country] co ON c.CountryId = co.CountryId
INNER JOIN [Data].[Stock] st ON sd.StockID = st.StockCode
INNER JOIN [Data].[Model] m ON st.ModelID = m.ModelID
INNER JOIN [Data].[Make] mk ON m.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2018
GO

PRINT 'Created view DataTransfer.Sales2018'
GO

-- Testing the views
PRINT 'Testing yearly views...'
SELECT COUNT(*) AS Sales2015Count FROM [DataTransfer].[Sales2015]
SELECT COUNT(*) AS Sales2016Count FROM [DataTransfer].[Sales2016]
SELECT COUNT(*) AS Sales2017Count FROM [DataTransfer].[Sales2017]
SELECT COUNT(*) AS Sales2018Count FROM [DataTransfer].[Sales2018]
GO


IF OBJECT_ID('[Output].[StockPrices]', 'U') IS NOT NULL DROP TABLE [Output].[StockPrices];
IF OBJECT_ID('[Output].[StockPrices]', 'V') IS NOT NULL DROP VIEW [Output].[StockPrices];
GO

CREATE VIEW [Output].[StockPrices] AS
SELECT
    mk.MakeName,
    m.ModelName,
    st.Cost
FROM [Data].[Make] mk
INNER JOIN [Data].[Model] m ON mk.MakeID = m.MakeID
INNER JOIN [Data].[Stock] st ON st.ModelID = m.ModelID
GO  

PRINT 'Created view Output.StockPrices'
GO

SELECT COUNT(*) AS StockPricesCount FROM [Output].[StockPrices]
GO