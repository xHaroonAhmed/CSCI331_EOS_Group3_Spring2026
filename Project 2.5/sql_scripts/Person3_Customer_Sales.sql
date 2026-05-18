
select * into PrestigeCars.data.Customer_backup from PrestigeCars.data.Customer

go

drop table if exists PrestigeCars.data.Customer

go

create table PrestigeCars.data.Customer(
CustomerID [Udt].[SurrogateKeyInt] identity(1,1) Primary key not null,
CustomerName [Udt].[CustomerName] null,
Address1 [Udt].[AddressLine] null,
Address2 [Udt].[AddressLine] null,
Town [Udt].[TownName] null,
PostalCode [Udt].[PostCode] null,
CountryId int
constraint FK_CountryId
   Foreign Key (CountryId)
   references PrestigeCars.Data.Country(CountryId),
[IsReseller] bit not null default 0,
[IsCreditRisk] bit not null default 0
);

go

insert into PrestigeCars.data.Customer
select CB.CustomerName,CB.Address1,CB.Address2,CB.Town,CB.PostCode,DC.CountryId,CB.IsReseller,CB.IsCreditRisk
from PrestigeCars.data.Customer_backup as CB
inner join [Data].[Country] as DC
on DC.CountryISO2 = CB.Country

go

select * into PrestigeCars.data.Sales_backup from PrestigeCars.data.Sales

go

drop table if exists PrestigeCars.data.Sales

go

create table PrestigeCars.data.Sales(
SalesID [Udt].[SurrogateKeyInt] identity(1,1) primary key not null,
CustomerID [Udt].[SurrogateKeyInt] not null
constraint FK_CustomerID
   foreign key (CustomerID)
   references PrestigeCars.data.Customer(CustomerID),
InvoiceNumber [Udt].[InvoiceNumber] not null,
TotalSalePrice [Udt].[SalesPrice] not null
constraint check_TotalSalePrice
   check (TotalSalePrice>=0),
SaleDate datetime not null
constraint check_SaleDate
   check (SaleDate <= getdate())
);

go

insert into PrestigeCars.data.Sales
select SB.CustomerID,SB.InvoiceNumber,SB.TotalSalePrice,SB.SaleDate
from PrestigeCars.data.Sales_backup as SB

go

create unique nonclustered index idx_Sales
on PrestigeCars.data.Sales([SalesID] asc)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF,
          SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,
          ONLINE = OFF, ALLOW_ROW_LOCKS = ON,
          ALLOW_PAGE_LOCKS = ON,
          OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
go



drop table if exists PrestigeCars.data.Customer_backup
go
drop table if exists PrestigeCars.data.Sales_backup