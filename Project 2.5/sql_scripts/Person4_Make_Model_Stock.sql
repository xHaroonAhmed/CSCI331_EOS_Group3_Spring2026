USE [PrestigeCars]
GO

EXEC sp_rename 'Data.Make', 'Make_OLD';
EXEC sp_rename 'Data.Model', 'Model_OLD';
EXEC sp_rename 'Data.Stock', 'Stock_OLD';
GO

CREATE TABLE [Data].[Make](
	[MakeID] [Udt].[SurrogateKeySmallInt] IDENTITY(1,1) NOT NULL,
	[MakeName] [Udt].[MakeName] NOT NULL,
	[CountryId] [Udt].[SurrogateKeyInt] NULL, 
 CONSTRAINT [PK_Make_New] PRIMARY KEY CLUSTERED ([MakeID] ASC)
) 
GO

CREATE TABLE [Data].[Model](
	[ModelID] [Udt].[SurrogateKeySmallInt] IDENTITY(1,1) NOT NULL,
	[MakeID] [Udt].[SurrogateKeySmallInt] NOT NULL,
	[ModelName] [Udt].[ModelName] NOT NULL,
    [YearFirstProduced] [Udt].[YearString] NULL,
 CONSTRAINT [PK_Model_New] PRIMARY KEY CLUSTERED ([ModelID] ASC)
) 
GO

CREATE TABLE [Data].[Stock](
	[StockID] [Udt].[SurrogateKeyInt] IDENTITY(1,1) NOT NULL,
	[StockCode] [Udt].[StockCode] NOT NULL,
	[ModelID] [Udt].[SurrogateKeySmallInt] NULL, 
	[Color] [Udt].[ColorName] NULL,
	[Cost] [Udt].[MoneyAmount] NULL,
    [RepairsCost] [Udt].[MoneyAmount] NULL,
    [BuyerComments] [Udt].[LongNotes] NULL,
 CONSTRAINT [PK_Stock_New] PRIMARY KEY CLUSTERED ([StockID] ASC)
) 
GO

ALTER TABLE [Data].[Make] ADD CONSTRAINT [UQ_MakeName_New] UNIQUE ([MakeName])
GO

ALTER TABLE [Data].[Make] WITH CHECK ADD CONSTRAINT [FK_Make_Country_New] FOREIGN KEY([CountryId])
REFERENCES [Data].[Country] ([CountryId]) 
GO

ALTER TABLE [Data].[Model] WITH CHECK ADD CONSTRAINT [FK_Model_Make_New] FOREIGN KEY([MakeID]) REFERENCES [Data].[Make] ([MakeID])
ALTER TABLE [Data].[Model] WITH CHECK ADD CONSTRAINT [CK_Model_Year_New] CHECK ([YearFirstProduced] LIKE '[1-2][0-9][0-9][0-9]')
GO

ALTER TABLE [Data].[Stock] WITH CHECK ADD CONSTRAINT [FK_Stock_Model_New] FOREIGN KEY([ModelID]) REFERENCES [Data].[Model] ([ModelID])
ALTER TABLE [Data].[Stock] WITH CHECK ADD CONSTRAINT [CK_Stock_Cost_New] CHECK ([Cost] >= 0)

ALTER TABLE [Data].[Stock] ADD CONSTRAINT [UQ_Stock_StockCode_New] UNIQUE ([StockCode])
GO
PRINT '*** FIXED: Added UNIQUE constraint on Stock.StockCode for Person 5 FK ***'
GO

CREATE NONCLUSTERED INDEX [IX_Stock_StockCode_New] ON [Data].[Stock] ([StockCode] ASC)
GO

SET IDENTITY_INSERT [Data].[Make] ON;
INSERT INTO [Data].[Make] ([MakeID], [MakeName], [CountryId])
SELECT 
    m.[MakeID], 
    m.[MakeName], 
    c.[CountryId] 
FROM [Data].[Make_OLD] m
LEFT JOIN [Data].[Country] c ON m.[MakeCountry] = c.[CountryISO3];
SET IDENTITY_INSERT [Data].[Make] OFF;
GO

-- Migrate Model
SET IDENTITY_INSERT [Data].[Model] ON;
INSERT INTO [Data].[Model] ([ModelID], [MakeID], [ModelName], [YearFirstProduced])
SELECT [ModelID], [MakeID], [ModelName], [YearFirstProduced] FROM [Data].[Model_OLD];
SET IDENTITY_INSERT [Data].[Model] OFF;
GO

-- Migrate Stock (With Ghost-Car Fix)
INSERT INTO [Data].[Stock] ([StockCode], [ModelID], [Color], [Cost], [RepairsCost], [BuyerComments])
SELECT 
    s.[StockCode], 
    CASE WHEN m.[ModelID] IS NOT NULL THEN s.[ModelID] ELSE NULL END, 
    s.[Color], s.[Cost], s.[RepairsCost], s.[BuyerComments] 
FROM [Data].[Stock_OLD] s
LEFT JOIN [Data].[Model] m ON s.[ModelID] = m.[ModelID];
GO

