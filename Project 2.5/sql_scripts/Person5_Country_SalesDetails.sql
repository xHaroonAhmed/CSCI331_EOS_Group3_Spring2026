USE [PrestigeCars]
GO

PRINT '======================================================'
PRINT 'DAY 3 - Person 5: Country Normalization Starting...'
PRINT '======================================================'
GO

IF OBJECT_ID('Data.Country_OLD', 'U') IS NOT NULL
    DROP TABLE Data.Country_OLD;
GO

SELECT *
INTO Data.Country_OLD
FROM Data.Country;
GO

PRINT 'STEP 1 DONE: Data.Country backed up to Data.Country_OLD'
SELECT COUNT(*) AS BackupRowCount FROM Data.Country_OLD;
GO

IF OBJECT_ID('Data.SalesRegion', 'U') IS NOT NULL
    DROP TABLE Data.SalesRegion;
GO

CREATE TABLE [Data].[SalesRegion]
(
    [SalesRegionId] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
    [SalesRegion]   [Udt].[SalesRegion]     NOT NULL,

    CONSTRAINT [PK_SalesRegion] PRIMARY KEY CLUSTERED
    (
        [SalesRegionId] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
            IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [UniqueSalesRegionName_idx]
    ON [Data].[SalesRegion] ([SalesRegion] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
          SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
          DROP_EXISTING = OFF, ONLINE = OFF,
          ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

PRINT 'STEP 2 DONE: Data.SalesRegion created.'
GO

INSERT INTO [Data].[SalesRegion] ([SalesRegion])
SELECT DISTINCT RTRIM(LTRIM([SalesRegion]))
FROM Data.Country_OLD
WHERE [SalesRegion] IS NOT NULL
ORDER BY RTRIM(LTRIM([SalesRegion]));
GO

PRINT 'STEP 3 DONE: Sales regions extracted.'
SELECT * FROM Data.SalesRegion;
GO


DROP TABLE [Data].[Country];
GO

PRINT 'STEP 4 DONE: Old Data.Country dropped.'
GO

CREATE TABLE [Data].[Country]
(
    [CountryId]     [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
    [CountryName]   [Udt].[CountryName]     NOT NULL,
    [CountryISO2]   [Udt].[ISO2]            NOT NULL,
    [CountryISO3]   [Udt].[ISO3]            NOT NULL,
    [SalesRegionId] [Udt].[SurrogateKeyInt] NOT NULL,

    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED
    (
        [CountryId] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
            IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON,
            OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

PRINT 'STEP 5 DONE: Data.Country recreated with UDTs.'
GO

CREATE UNIQUE NONCLUSTERED INDEX [UniqueCoutryName_idx]
    ON [Data].[Country] ([CountryName] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
          SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
          DROP_EXISTING = OFF, ONLINE = OFF,
          ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
          OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [UniqueCoutryNameISO2_idx]
    ON [Data].[Country] ([CountryISO2] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
          SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,
          ONLINE = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON,
          OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX [UniqueCoutryNameISO3_idx]
    ON [Data].[Country] ([CountryISO3] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
          SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
          DROP_EXISTING = OFF, ONLINE = OFF,
          ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
          OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

PRINT 'STEP 6 DONE: Indexes added to Data.Country.'
GO

ALTER TABLE [Data].[Country] WITH CHECK
    ADD CONSTRAINT [FK_Country_SalesRegion]
    FOREIGN KEY ([SalesRegionId])
    REFERENCES [Data].[SalesRegion] ([SalesRegionId])
GO
ALTER TABLE [Data].[Country] CHECK CONSTRAINT [FK_Country_SalesRegion]
GO

ALTER TABLE [Data].[Country] WITH CHECK
    ADD CONSTRAINT [CK_CountryISO2]
    CHECK (([CountryISO2] LIKE '[A-Z][A-Z]'))
GO
ALTER TABLE [Data].[Country] CHECK CONSTRAINT [CK_CountryISO2]
GO

ALTER TABLE [Data].[Country] WITH CHECK
    ADD CONSTRAINT [CK_CountryISO3]
    CHECK (([CountryISO3] LIKE '[A-Z][A-Z][A-Z]'))
GO
ALTER TABLE [Data].[Country] CHECK CONSTRAINT [CK_CountryISO3]
GO

PRINT 'STEP 7 DONE: FK and check constraints added to Data.Country.'
GO

INSERT INTO [Data].[Country]
    ([CountryName], [CountryISO2], [CountryISO3], [SalesRegionId])
SELECT
    RTRIM(LTRIM(old.[CountryName]))  AS CountryName,
    RTRIM(old.[CountryISO2])         AS CountryISO2,  -- trim nchar padding
    RTRIM(old.[CountryISO3])         AS CountryISO3,  -- trim nchar padding
    sr.[SalesRegionId]
FROM Data.Country_OLD AS old
INNER JOIN Data.SalesRegion AS sr
    ON sr.[SalesRegion] = RTRIM(LTRIM(old.[SalesRegion]));
GO

PRINT 'STEP 8 DONE: Country data migrated.'
SELECT COUNT(*) AS MigratedRowCount FROM Data.Country;
GO

SELECT
    c.CountryId,
    c.CountryName,
    c.CountryISO2,
    c.CountryISO3,
    sr.SalesRegion
FROM Data.Country AS c
INNER JOIN Data.SalesRegion AS sr
    ON c.SalesRegionId = sr.SalesRegionId
ORDER BY sr.SalesRegion, c.CountryName;
GO

SELECT 'Country_OLD' AS TableName, COUNT(*) AS TotalRows FROM Data.Country_OLD
UNION ALL
SELECT 'Country_NEW',              COUNT(*)              FROM Data.Country;
GO

SELECT
    CONCAT(TABLE_SCHEMA, '.', TABLE_NAME) AS TableName,
    COLUMN_NAME,
    DOMAIN_NAME AS UDT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Country', 'SalesRegion')
  AND DOMAIN_NAME IS NOT NULL
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO

PRINT '======================================================'
PRINT '*** CHECKPOINT: Country normalization COMPLETE ***'
PRINT ''
PRINT 'Data.SalesRegion -> SalesRegionId, SalesRegion'
PRINT 'Data.Country     -> CountryId, CountryName,'
PRINT '                    CountryISO2, CountryISO3, SalesRegionId'
PRINT ''
PRINT 'NOTIFY Person 3 (Customer & Sales) --> UNBLOCKED'
PRINT '  Reference CountryId for your Customer FK'
PRINT ''
PRINT 'NOTIFY Person 4 (Make, Model, Stock) --> UNBLOCKED'
PRINT '  Reference CountryId for your Make FK if needed'
PRINT '======================================================'
GO

PRINT '======================================================'
PRINT 'DAY 4-5 - Person 5: SalesDetails Rebuild Starting...'
PRINT 'REQUIRES: Person 3 Sales + Person 4 Stock complete!'
PRINT '======================================================'
GO

IF OBJECT_ID('Data.SalesDetails_OLD', 'U') IS NOT NULL
    DROP TABLE Data.SalesDetails_OLD;
GO

SELECT *
INTO Data.SalesDetails_OLD
FROM Data.SalesDetails;
GO

PRINT 'STEP 10 DONE: Data.SalesDetails backed up to Data.SalesDetails_OLD.'
SELECT COUNT(*) AS BackupRowCount FROM Data.SalesDetails_OLD;
GO

DROP TABLE [Data].[SalesDetails];
GO

PRINT 'STEP 11 DONE: Old Data.SalesDetails dropped.'
GO

CREATE TABLE [Data].[SalesDetails]
(
    [SalesDetailsID]    INT                         NOT NULL IDENTITY(1,1),
    [SalesID]           [Udt].[SurrogateKeyInt]     NULL,
    [LineItemNumber]    TINYINT                     NULL,
    [StockID]           [Udt].[StockCode]           NULL,
    [SalePrice]         [Udt].[SalesPrice]          NULL,
    [LineItemDiscount]  [Udt].[SalesPrice]          NULL,

    CONSTRAINT [PK_SalesDetails] PRIMARY KEY CLUSTERED
    (
        [SalesDetailsID] ASC
    ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
            IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
            ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

PRINT 'STEP 12 DONE: Data.SalesDetails recreated with UDTs.'
GO

ALTER TABLE [Data].[SalesDetails]
    ADD CONSTRAINT [CK_SalesDetails_SalePrice_NonNegative]
    CHECK (SalePrice IS NULL OR SalePrice >= 0);
GO

ALTER TABLE [Data].[SalesDetails]
    ADD CONSTRAINT [CK_SalesDetails_Discount_NonNegative]
    CHECK (LineItemDiscount IS NULL OR LineItemDiscount >= 0);
GO

PRINT 'NOTE: CK_SalesDetails_Discount_LTE_SalePrice skipped - source data anomaly row 327'
GO

ALTER TABLE [Data].[SalesDetails]
    ADD CONSTRAINT [CK_SalesDetails_LineItemNumber_Positive]
    CHECK (LineItemNumber IS NULL OR LineItemNumber >= 1);
GO

PRINT 'STEP 13 DONE: Constraints added to Data.SalesDetails.'
GO

ALTER TABLE [Data].[SalesDetails]
    ADD CONSTRAINT [FK_SalesDetails_Sales]
    FOREIGN KEY ([SalesID])
    REFERENCES [Data].[Sales] ([SalesID]);
GO

ALTER TABLE [Data].[SalesDetails]
    ADD CONSTRAINT [FK_SalesDetails_Stock]
    FOREIGN KEY ([StockID])
    REFERENCES [Data].[Stock] ([StockCode]);
GO

PRINT 'STEP 14 DONE: FKs to Sales and Stock added.'
GO

CREATE INDEX [IX_SalesDetails_SalesID]
    ON [Data].[SalesDetails] ([SalesID]);
GO

CREATE INDEX [IX_SalesDetails_StockID]
    ON [Data].[SalesDetails] ([StockID]);
GO

PRINT 'STEP 15 DONE: Indexes added to Data.SalesDetails.'
GO

INSERT INTO [Data].[SalesDetails]
    ([SalesID], [LineItemNumber], [StockID], [SalePrice], [LineItemDiscount])
SELECT
    [SalesID],
    [LineItemNumber],
    [StockID],
    [SalePrice],
    [LineItemDiscount]
FROM Data.SalesDetails_OLD;
GO

PRINT 'STEP 16 DONE: SalesDetails_OLD data migrated.'
SELECT COUNT(*) AS MigratedRowCount FROM Data.SalesDetails;
GO

PRINT '======================================================'
PRINT 'FINAL VERIFICATION - All Person 5 Tables'
PRINT '======================================================'

PRINT '--- Data.SalesRegion ---'
SELECT * FROM Data.SalesRegion ORDER BY SalesRegion;
GO

PRINT '--- Data.Country (all rows) ---'
SELECT
    c.CountryId,
    c.CountryName,
    c.CountryISO2,
    c.CountryISO3,
    sr.SalesRegion
FROM Data.Country c
INNER JOIN Data.SalesRegion sr ON c.SalesRegionId = sr.SalesRegionId
ORDER BY c.CountryName;
GO

PRINT '--- Data.SalesDetails (top 10) ---'
SELECT TOP 10 * FROM Data.SalesDetails ORDER BY SalesDetailsID;
GO

PRINT '--- Row Count Validation ---'
SELECT 'Country_OLD'      AS TableName, COUNT(*) AS TotalRows FROM Data.Country_OLD
UNION ALL
SELECT 'Country_NEW'      ,             COUNT(*)              FROM Data.Country
UNION ALL
SELECT 'SalesDetails_OLD' ,             COUNT(*)              FROM Data.SalesDetails_OLD
UNION ALL
SELECT 'SalesDetails_NEW' ,             COUNT(*)              FROM Data.SalesDetails;
GO

PRINT '--- UDT Column Confirmation ---'
SELECT
    CONCAT(TABLE_SCHEMA, '.', TABLE_NAME) AS TableName,
    COLUMN_NAME,
    DOMAIN_NAME AS UDT_Applied
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('Country', 'SalesRegion', 'SalesDetails')
  AND DOMAIN_NAME IS NOT NULL
ORDER BY TABLE_NAME, ORDINAL_POSITION;
GO
