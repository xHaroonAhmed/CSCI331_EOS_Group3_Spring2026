
USE [PrestigeCars]
GO

-- Udt schema (holds all user-defined types)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Udt')
BEGIN
    EXEC('CREATE SCHEMA [Udt]')
    PRINT 'Schema [Udt] created.'
END
ELSE
    PRINT 'Schema [Udt] already exists - skipping.'
GO

-- Utils schema (holds metadata/utility views)
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'Utils')
BEGIN
    EXEC('CREATE SCHEMA [Utils]')
    PRINT 'Schema [Utils] created.'
END
ELSE
    PRINT 'Schema [Utils] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'SurrogateKeyInt' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[SurrogateKeyInt] FROM [int] NULL
    PRINT 'UDT [Udt].[SurrogateKeyInt] created.'
END
ELSE
    PRINT 'UDT [Udt].[SurrogateKeyInt] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'SurrogateKeySmallInt' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[SurrogateKeySmallInt] FROM [smallint] NULL
    PRINT 'UDT [Udt].[SurrogateKeySmallInt] created.'
END
ELSE
    PRINT 'UDT [Udt].[SurrogateKeySmallInt] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'CustomerName' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[CustomerName] FROM [nvarchar](150) NULL
    PRINT 'UDT [Udt].[CustomerName] created.'
END
ELSE
    PRINT 'UDT [Udt].[CustomerName] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'CountryName' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[CountryName] FROM [nvarchar](15) NOT NULL
    PRINT 'UDT [Udt].[CountryName] created.'
END
ELSE
    PRINT 'UDT [Udt].[CountryName] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'SalesRegion' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[SalesRegion] FROM [nvarchar](15) NULL
    PRINT 'UDT [Udt].[SalesRegion] created.'
END
ELSE
    PRINT 'UDT [Udt].[SalesRegion] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'AddressLine' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[AddressLine] FROM [nvarchar](50) NULL
    PRINT 'UDT [Udt].[AddressLine] created.'
END
ELSE
    PRINT 'UDT [Udt].[AddressLine] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'TownName' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[TownName] FROM [nvarchar](50) NULL
    PRINT 'UDT [Udt].[TownName] created.'
END
ELSE
    PRINT 'UDT [Udt].[TownName] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'PostCode' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[PostCode] FROM [nvarchar](50) NULL
    PRINT 'UDT [Udt].[PostCode] created.'
END
ELSE
    PRINT 'UDT [Udt].[PostCode] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'MakeName' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[MakeName] FROM [nvarchar](100) NULL
    PRINT 'UDT [Udt].[MakeName] created.'
END
ELSE
    PRINT 'UDT [Udt].[MakeName] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'ModelName' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[ModelName] FROM [nvarchar](150) NULL
    PRINT 'UDT [Udt].[ModelName] created.'
END
ELSE
    PRINT 'UDT [Udt].[ModelName] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'ISO2' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[ISO2] FROM [nchar](2) NULL
    PRINT 'UDT [Udt].[ISO2] created.'
END
ELSE
    PRINT 'UDT [Udt].[ISO2] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'ISO3' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[ISO3] FROM [nchar](3) NULL
    PRINT 'UDT [Udt].[ISO3] created.'
END
ELSE
    PRINT 'UDT [Udt].[ISO3] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'YearString' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[YearString] FROM [char](4) NULL
    PRINT 'UDT [Udt].[YearString] created.'
END
ELSE
    PRINT 'UDT [Udt].[YearString] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'InvoiceNumber' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[InvoiceNumber] FROM [char](8) NULL
    PRINT 'UDT [Udt].[InvoiceNumber] created.'
END
ELSE
    PRINT 'UDT [Udt].[InvoiceNumber] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'CustomerCode' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[CustomerCode] FROM [nvarchar](5) NOT NULL
    PRINT 'UDT [Udt].[CustomerCode] created.'
END
ELSE
    PRINT 'UDT [Udt].[CustomerCode] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'MoneyAmount' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[MoneyAmount] FROM [money] NULL
    PRINT 'UDT [Udt].[MoneyAmount] created.'
END
ELSE
    PRINT 'UDT [Udt].[MoneyAmount] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'SalesPrice' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[SalesPrice] FROM [numeric](18, 2) NULL
    PRINT 'UDT [Udt].[SalesPrice] created.'
END
ELSE
    PRINT 'UDT [Udt].[SalesPrice] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'StockCode' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[StockCode] FROM [nvarchar](50) NULL
    PRINT 'UDT [Udt].[StockCode] created.'
END
ELSE
    PRINT 'UDT [Udt].[StockCode] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'ColorName' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[ColorName] FROM [nvarchar](50) NULL
    PRINT 'UDT [Udt].[ColorName] created.'
END
ELSE
    PRINT 'UDT [Udt].[ColorName] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'LongNotes' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[LongNotes] FROM [nvarchar](4000) NULL
    PRINT 'UDT [Udt].[LongNotes] created.'
END
ELSE
    PRINT 'UDT [Udt].[LongNotes] already exists - skipping.'
GO

IF NOT EXISTS (SELECT 1 FROM sys.types WHERE name = 'MakeCountryCode' AND schema_id = SCHEMA_ID('Udt'))
BEGIN
    CREATE TYPE [Udt].[MakeCountryCode] FROM [char](3) NULL
    PRINT 'UDT [Udt].[MakeCountryCode] created.'
END
ELSE
    PRINT 'UDT [Udt].[MakeCountryCode] already exists - skipping.'
GO

IF OBJECT_ID('[Utils].[uvw_FindColumnDefinition]', 'V') IS NOT NULL
    DROP VIEW [Utils].[uvw_FindColumnDefinition]
GO

CREATE VIEW [Utils].[uvw_FindColumnDefinition]
AS
SELECT
    CONCAT(tbl.TABLE_SCHEMA, '.', tbl.TABLE_NAME)       AS FullyQualifiedTableName,
    tbl.TABLE_SCHEMA                                     AS SchemaName,
    tbl.TABLE_NAME                                       AS TableName,
    col.COLUMN_NAME                                      AS ColumnName,
    col.ORDINAL_POSITION                                 AS OrdinalPosition,
    CONCAT(col.DOMAIN_SCHEMA, '.', col.DOMAIN_NAME)      AS FullyQualifiedDomainName,
    col.DOMAIN_NAME                                      AS DomainName,
    CASE
        WHEN col.DATA_TYPE = 'varchar'  THEN CONCAT('varchar(',  col.CHARACTER_MAXIMUM_LENGTH, ')')
        WHEN col.DATA_TYPE = 'char'     THEN CONCAT('char(',     col.CHARACTER_MAXIMUM_LENGTH, ')')
        WHEN col.DATA_TYPE = 'nvarchar' THEN CONCAT('nvarchar(', col.CHARACTER_MAXIMUM_LENGTH, ')')
        WHEN col.DATA_TYPE = 'nchar'    THEN CONCAT('nchar(',    col.CHARACTER_MAXIMUM_LENGTH, ')')
        WHEN col.DATA_TYPE = 'numeric'  THEN CONCAT('numeric(',  col.NUMERIC_PRECISION_RADIX, ', ', col.NUMERIC_SCALE, ')')
        WHEN col.DATA_TYPE = 'decimal'  THEN CONCAT('decimal(',  col.NUMERIC_PRECISION_RADIX, ', ', col.NUMERIC_SCALE, ')')
        ELSE col.DATA_TYPE
    END                                                  AS DataType,
    col.IS_NULLABLE                                      AS IsNullable,
    dcn.DefaultName,
    col.COLUMN_DEFAULT                                   AS DefaultNameDefinition,
    cc.CONSTRAINT_NAME                                   AS CheckConstraintRuleName,
    cc.CHECK_CLAUSE                                      AS CheckConstraintRuleNameDefinition
FROM
(
    SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = 'BASE TABLE'
) AS tbl
INNER JOIN
(
    SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME,
           ORDINAL_POSITION, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE,
           CHARACTER_MAXIMUM_LENGTH, CHARACTER_OCTET_LENGTH,
           NUMERIC_PRECISION, NUMERIC_PRECISION_RADIX, NUMERIC_SCALE,
           DATETIME_PRECISION, CHARACTER_SET_CATALOG, CHARACTER_SET_SCHEMA,
           CHARACTER_SET_NAME, COLLATION_CATALOG, COLLATION_SCHEMA,
           COLLATION_NAME, DOMAIN_CATALOG, DOMAIN_SCHEMA, DOMAIN_NAME
    FROM INFORMATION_SCHEMA.COLUMNS
) AS col
    ON  col.TABLE_CATALOG = tbl.TABLE_CATALOG
    AND col.TABLE_SCHEMA  = tbl.TABLE_SCHEMA
    AND col.TABLE_NAME    = tbl.TABLE_NAME
LEFT OUTER JOIN
(
    SELECT t.name                   AS TableName,
           SCHEMA_NAME(s.schema_id) AS SchemaName,
           ac.name                  AS ColumnName,
           d.name                   AS DefaultName
    FROM sys.all_columns                   AS ac
    INNER JOIN sys.tables              AS t  ON ac.object_id         = t.object_id
    INNER JOIN sys.schemas             AS s  ON t.schema_id          = s.schema_id
    INNER JOIN sys.default_constraints AS d  ON ac.default_object_id = d.object_id
) AS dcn
    ON  dcn.SchemaName = tbl.TABLE_SCHEMA
    AND dcn.TableName  = tbl.TABLE_NAME
    AND dcn.ColumnName = col.COLUMN_NAME
LEFT OUTER JOIN
(
    SELECT cu.TABLE_CATALOG, cu.TABLE_SCHEMA, cu.TABLE_NAME, cu.COLUMN_NAME,
           c.CONSTRAINT_CATALOG, c.CONSTRAINT_SCHEMA, c.CONSTRAINT_NAME, c.CHECK_CLAUSE
    FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE     AS cu
    INNER JOIN INFORMATION_SCHEMA.CHECK_CONSTRAINTS AS c
        ON c.CONSTRAINT_NAME = cu.CONSTRAINT_NAME
) AS cc
    ON  cc.TABLE_SCHEMA = tbl.TABLE_SCHEMA
    AND cc.TABLE_NAME   = tbl.TABLE_NAME
    AND cc.COLUMN_NAME  = col.COLUMN_NAME;
GO

PRINT 'View [Utils].[uvw_FindColumnDefinition] created.'
GO

SELECT
    s.name          AS SchemaName,
    t.name          AS TypeName,
    bt.name         AS BaseType,
    t.max_length    AS MaxLength,
    t.is_nullable   AS IsNullable
FROM sys.types t
INNER JOIN sys.schemas s  ON t.schema_id = s.schema_id
INNER JOIN sys.types   bt ON t.system_type_id = bt.system_type_id
                          AND bt.is_user_defined = 0
WHERE s.name = 'Udt'
ORDER BY t.name;
GO

SELECT OBJECT_NAME(object_id) AS ViewName, create_date, modify_date
FROM sys.objects
WHERE type = 'V' AND schema_id = SCHEMA_ID('Utils');
GO
