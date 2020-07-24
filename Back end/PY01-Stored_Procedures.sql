

use WideWorldImporters;

go
--Consultas

--Datos completos proveedores
create or alter procedure proveedoresFullData
@idProveedor int
as 
begin
select SupplierID, SupplierName, SupplierReference,BankAccountName,BankAccountBranch, BankAccountNumber, PhoneNumber,
WebsiteURL,DeliveryAddressLine2, PostalAddressLine1,PostalPostalCode,ValidFrom, ValidTo from Purchasing.Suppliers
where SupplierID=@idProveedor;
end

go
-- Info basica proveedores
create or alter procedure proveedoresBasicosFiltro

  @NombreProveedor varchar(50) = null,
  @CategoriaProveedor varchar(50)= null,
  @DireccionProveedor varchar(100) = null
 as

 Begin
 declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)
set @ParameterDef = '@NombreProveedor varchar(50), @CategoriaProveedor varchar(50), @DireccionProveedor varchar(100)'
set @query ='
select SupplierID,SupplierName NombreProveedor,SupplierCategoryName CategoriaProveedor,DeliveryAddressLine2 DireccionProveedor,CityName
 from Purchasing.Suppliers su inner join Purchasing.SupplierCategories ca
on su.SupplierCategoryID=ca.SupplierCategoryID
inner join Application.Cities ac
on ac.CityID = su.DeliveryCityID
where 1 = 1 '


if @CategoriaProveedor is not null
	set @query = @query + ' and SupplierCategoryName like ''%''+@CategoriaProveedor+''%'''
if @NombreProveedor is not null
	set @query = @query + ' and SupplierName like ''%''+@NombreProveedor+''%'''

if @DireccionProveedor is not null
	set @query = @query + ' and CityName like ''%''+@DireccionProveedor+''%'''

set @query = @query + 'order by SupplierName asc';
exec sp_executesql @query, @ParameterDef, @CategoriaProveedor = @CategoriaProveedor, @NombreProveedor = @NombreProveedor, @DireccionProveedor = @DireccionProveedor;

END
go

--Basic Client Data

create or alter procedure basicClientData (
@customerName varchar(50) = null,
@category varchar(50) = null,
@city varchar(50) = null,
@initDate date = null,
@lastDate date = null,
@pageNumber int = null,
@pageSize int = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)

set @ParameterDef = '@customerName varchar(50), @category varchar(50), @city varchar(50), @initDate date, @lastDate date, @pageNumber int, @pageSize int'
set @query = N'select CustomerID, CustomerName FullName, CustomerCategoryName Category, PhoneNumber, WebsiteURL, AccountOpenedDate, CityName City, DeliveryAddressLine1+ '', '' +DeliveryAddressLine2 DeliveryAddress, DeliveryPostalCode PostalCode, DeliveryLocation, PostalAddressLine1+ '', '' +PostalAddressLine2 PostalAddress
from Sales.Customers sc
inner join Sales.CustomerCategories scc
on scc.CustomerCategoryID = sc.CustomerCategoryID
inner join Application.Cities ac
on ac.CityID = sc.DeliveryCityID
where 1 = 1'

if @customerName is not null
	set @query = @query + ' and CustomerName like ''%''+@customerName+''%'''

if @category is not null
	set @query = @query + ' and CustomerCategoryName like ''%''+@category+''%'''

if @city is not null
	set @query = @query + ' and CityName like ''%''+@city+''%'''

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (AccountOpenedDate >= @initDate and AccountOpenedDate <= @lastDate)'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and AccountOpenedDate = @initDate'

set @query = @query + ' order by CustomerID'

if @pageNumber is not null and @pageSize is not null
	set @query = @query + ' OFFSET @PageSize * (@PageNumber - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)'

exec sp_executesql @query, @ParameterDef, @customerName = @customerName, @category = @category, @city= @city, @initDate = @initDate, @lastDate= @lastDate, @pageNumber = @pageNumber, @pageSize = @pageSize
end;
go
--Full client data
create or alter procedure completeClientData 
@customerID int

as
begin

select CustomerID, CustomerName FullName, CustomerCategoryName Category, ISNULL(CreditLimit,0) CreditLimit, PhoneNumber, WebsiteURL, DeliveryMethodName DeliveryMethod, CityName City, DeliveryAddressLine1, DeliveryAddressLine2, DeliveryPostalCode, DeliveryLocation, PostalAddressLine1, PostalAddressLine2, PostalPostalCode
from Sales.Customers sc
inner join Sales.CustomerCategories scc
on scc.CustomerCategoryID = sc.CustomerCategoryID
inner join Application.DeliveryMethods adm
on adm.DeliveryMethodID = sc.DeliveryMethodID
inner join Application.Cities ac
on ac.CityID = sc.DeliveryCityID
where CustomerID = @customerID;
end;
go
--BasicInvoice
create or alter procedure basicClientInvoice (
@customerID int,
@initDate date = null,
@lastDate date = null,
@pageNumber int = null,
@pageSize int = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)

set @ParameterDef = '@customerID int, @initDate date, @lastDate date, @pageNumber int, @pageSize int'
set @query = N'select InvoiceID, InvoiceDate, DeliveryMethodName DeliveryMethod, ConfirmedDeliveryTime, ConfirmedReceivedBy
from Sales.Invoices si
inner join Application.DeliveryMethods adm
on adm.DeliveryMethodID = si.DeliveryMethodID  
where CustomerID = @customerID'

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (InvoiceDate >= @initDate and InvoiceDate <= @lastDate)'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and InvoiceDate = @initDate'

set @query = @query + ' order by InvoiceID'

if @pageNumber is not null and @pageSize is not null
	set @query = @query + ' OFFSET @PageSize * (@PageNumber - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)'

exec sp_executesql @query, @ParameterDef, @customerID = @customerID, @initDate = @initDate, @lastDate= @lastDate, @pageNumber = @pageNumber, @pageSize = @pageSize
end;
go
--FullInvoice
create or alter procedure completeClientInvoice (
@invoiceID int)

as
begin

select si.InvoiceID, CustomerName Customer, OrderID, DeliveryMethodName DeliveryMethod, FullName PackedByPerson, InvoiceDate, DeliveryInstructions, ReturnedDeliveryData, ConfirmedDeliveryTime, ConfirmedReceivedBy
from Sales.Invoices si
inner join Sales.Customers sc
on sc.CustomerID = si.CustomerID
inner join Application.People ap
on ap.PersonID = PackedByPersonID
inner join Application.DeliveryMethods adm
on adm.DeliveryMethodID = si.DeliveryMethodID 
where si.InvoiceID = @invoiceID;
end;

go
--InvoiceLine
create or alter procedure invoiceTotal (
@invoiceID int)

as
begin

select case when cast(grouping(InvoiceID) as varchar(30)) = '1' then '' else cast(InvoiceID as varchar(30)) end as InvoiceID,
case when cast(grouping(InvoiceLineID) as varchar(30)) = '1' then '' else cast(InvoiceLineID as varchar(30)) end as InvoiceLineID,
case when cast(grouping(StockItemID) as varchar(30)) = '1' then '' else cast(StockItemID as varchar(30)) end as StockItemID,
case when cast(grouping(Description) as varchar(250)) = '1' then 'Total' else cast(Description as varchar(250)) end as Description,
case when cast(grouping(PackageTypeName) as varchar(50)) = '1' then '' else cast(PackageTypeName as varchar(50)) end as PackageType,
sum(Quantity) Quantity, sum(UnitPrice) UnitPrice, sum(TaxAmount) TaxAmount, sum(ExtendedPrice) ExtendedPrice
from Sales.InvoiceLines sil
inner join Warehouse.PackageTypes wpt
on wpt.PackageTypeID = sil.PackageTypeID
where sil.InvoiceID = @invoiceID
group by rollup ((InvoiceID,InvoiceLineID, StockItemID, Description, PackageTypeName));
end;

go
--Estadisticas
--Top 5
create or alter procedure Top5CountrySales(
@product varchar(50) = null,
@supplier varchar(50) = null,
@supplierCategory varchar(50) = null,
@initDate date = null,
@lastDate date = null,
@customerCategory varchar(50) = null,
@itemCategory varchar(50) = null,
@country varchar(50) = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)

set @ParameterDef = '@product varchar(50), @supplier varchar(50), @supplierCategory varchar(50), @initDate date, @lastDate date, @customerCategory varchar(50), @itemCategory varchar(50),@country varchar(50)'
set @query = N'select top 5 year(InvoiceDate) Year, StateProvinceName, CountryName, sum(ExtendedPrice) TotalSales, DENSE_RANK() over (order by sum(ExtendedPrice)) as Ranking
from Application.Countries aco
inner join Application.StateProvinces asp
on aco.CountryID = asp.CountryID
inner join Application.Cities aci
on aci.StateProvinceID = asp.StateProvinceID
inner join Sales.Customers sc
on sc.DeliveryCityID = aci.CityID
inner join Sales.CustomerCategories scc
on scc.CustomerCategoryID = sc.CustomerCategoryID
inner join Sales.Invoices si
on si.CustomerID = sc.CustomerID
inner join Sales.InvoiceLines sil
on sil.InvoiceID = si.InvoiceID
inner join Warehouse.StockItemStockGroups wsisg
on sil.StockItemID = wsisg.StockItemID
inner join Warehouse.StockGroups wsg
on wsisg.StockGroupID = wsg.StockGroupID
inner join Warehouse.StockItems wsi
on wsi.StockItemID = sil.StockItemID
inner join Purchasing.Suppliers ps
on ps.SupplierID = wsi.SupplierID
inner join Purchasing.SupplierCategories psc
on psc.SupplierCategoryID = ps.SupplierCategoryID
where 1 = 1'

if @supplier is not null
	set @query = @query + ' and ps.SupplierName like ''%''+@supplier+''%'''

if @supplierCategory is not null
	set @query = @query + ' and psc.SupplierCategoryName like ''%''+@supplierCategory+''%'''

if @customerCategory is not null
	set @query = @query + ' and scc.CustomerCategoryName like ''%''+@customerCategory+''%'''

if @product is not null
	set @query = @query + ' and sil.Description like ''%''+@product+''%'''

if @itemCategory is not null
	set @query = @query + ' and wsg.StockGroupName like ''%''+@itemCategory+''%'''

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (year(InvoiceDate) >= year(@initDate) and year(InvoiceDate) <= year(@lastDate))'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and year(InvoiceDate) = year(@initDate)'

if @country is not null
	set @query = @query + ' and CountryName like ''%''+@country+''%'''

set @query = @query + ' group by year(InvoiceDate), StateProvinceName, CountryName'

exec sp_executesql @query, @ParameterDef, @product = @product, @supplierCategory = @supplierCategory, @initDate = @initDate, @lastDate = @lastDate, @customerCategory = @customerCategory, @itemCategory = @itemCategory, @supplier = @supplier, @country = @country

end;

go
--Top 3
create or alter procedure Top3ItemSales(
@product varchar(50) = null,
@supplier varchar(50) = null,
@supplierCategory varchar(50) = null,
@initDate date = null,
@lastDate date = null,
@customerCategory varchar(50) = null,
@itemCategory varchar(50) = null,
@city varchar(50) = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)

set @ParameterDef = '@product varchar(50), @supplier varchar(50), @supplierCategory varchar(50), @initDate date, @lastDate date, @customerCategory varchar(50), @itemCategory varchar(50),@city varchar(50)'
set @query = N'select top 3 StockGroupName, StockItemName, sum(ExtendedPrice) TotalSales, DENSE_RANK() over (partition by StockGroupName order by sum(ExtendedPrice)) as Ranking
from Warehouse.StockGroups wsg
inner join Warehouse.StockItemStockGroups wsisg
on wsisg.StockGroupID = wsg.StockGroupID
inner join Warehouse.StockItems wsi
on wsi.StockItemID = wsisg.StockItemID
inner join Sales.InvoiceLines sil
on sil.StockItemID = wsisg.StockItemID
inner join Sales.Invoices si
on si.InvoiceID = sil.InvoiceID
inner join Purchasing.Suppliers ps
on ps.SupplierID = wsi.SupplierID
inner join Purchasing.SupplierCategories psc
on psc.SupplierCategoryID = ps.SupplierCategoryID
inner join Sales.Customers sc
on si.CustomerID = sc.CustomerID
inner join Sales.CustomerCategories scc
on scc.CustomerCategoryID = sc.CustomerCategoryID
inner join Application.Cities aci
on aci.CityID = sc.DeliveryCityID'

if @supplier is not null
	set @query = @query + ' and ps.SupplierName like ''%''+@supplier+''%'''

if @supplierCategory is not null
	set @query = @query + ' and psc.SupplierCategoryName like ''%''+@supplierCategory+''%'''

if @customerCategory is not null
	set @query = @query + ' and scc.CustomerCategoryName like ''%''+@customerCategory+''%'''

if @product is not null
	set @query = @query + ' and sil.Description like ''%''+@product+''%'''

if @itemCategory is not null
	set @query = @query + ' and wsg.StockGroupName like ''%''+@itemCategory+''%'''

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (InvoiceDate >= @initDate and InvoiceDate <= @lastDate)'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and InvoiceDate = @initDate'

if @city is not null
	set @query = @query + ' and CityName like ''%''+@city+''%'''

set @query = @query + ' group by StockGroupName, wsg.StockGroupID, StockItemName
order by ranking;'

exec sp_executesql @query, @ParameterDef, @product = @product, @supplierCategory = @supplierCategory, @initDate = @initDate, @lastDate = @lastDate, @customerCategory = @customerCategory, @itemCategory = @itemCategory, @supplier = @supplier, @city = @city

end;
go

--BestMonthItemSales
create or alter procedure BestMonthItemSales(
@product varchar(50) = null,
@supplier varchar(50) = null,
@supplierCategory varchar(50) = null,
@initDate date = null,
@lastDate date = null,
@customerCategory varchar(50) = null,
@itemCategory varchar(50) = null,
@city varchar(50) = null,
@pageNumber int = null,
@pageSize int = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)

set @ParameterDef = '@product varchar(50), @supplier varchar(50), @supplierCategory varchar(50), @initDate date, @lastDate date, @customerCategory varchar(50), @itemCategory varchar(50), @city varchar(50), @pageNumber int, @pageSize int'
set @query = N'select StockGroupName, StockItemName, year(InvoiceDate) Year, month(InvoiceDate) Month, sum(ExtendedPrice) TotalSales, DENSE_RANK() over (partition by month(InvoiceDate) order by sum(ExtendedPrice) desc) as Ranking
from Warehouse.StockGroups wsg
inner join Warehouse.StockItemStockGroups wsisg
on wsisg.StockGroupID = wsg.StockGroupID
inner join Warehouse.StockItems wsi
on wsi.StockItemID = wsisg.StockItemID
inner join Sales.InvoiceLines sil
on sil.StockItemID = wsisg.StockItemID
inner join Sales.Invoices si
on si.InvoiceID = sil.InvoiceID
inner join Purchasing.Suppliers ps
on ps.SupplierID = wsi.SupplierID
inner join Purchasing.SupplierCategories psc
on psc.SupplierCategoryID = ps.SupplierCategoryID
inner join Sales.Customers sc
on si.CustomerID = sc.CustomerID
inner join Sales.CustomerCategories scc
on scc.CustomerCategoryID = sc.CustomerCategoryID
inner join Application.Cities aci
on aci.CityID = sc.DeliveryCityID'

if @supplier is not null
	set @query = @query + ' and ps.SupplierName like ''%''+@supplier+''%'''

if @supplierCategory is not null
	set @query = @query + ' and psc.SupplierCategoryName like ''%''+@supplierCategory+''%'''

if @customerCategory is not null
	set @query = @query + ' and scc.CustomerCategoryName like ''%''+@customerCategory+''%'''

if @product is not null
	set @query = @query + ' and sil.Description like ''%''+@product+''%'''

if @itemCategory is not null
	set @query = @query + ' and wsg.StockGroupName like ''%''+@itemCategory+''%'''

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (InvoiceDate >= @initDate and InvoiceDate <= @lastDate)'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and InvoiceDate = @initDate'

if @city is not null
	set @query = @query + ' and CityName like ''%''+@city+''%'''

set @query = @query + ' group by StockGroupName, StockItemName, InvoiceDate
order by sum(ExtendedPrice) desc' 

if @pageNumber is not null and @pageSize is not null
	set @query = @query + ' OFFSET @PageSize * (@PageNumber - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)'

exec sp_executesql @query, @ParameterDef, @product = @product, @supplierCategory = @supplierCategory, @initDate = @initDate, @lastDate = @lastDate, @customerCategory = @customerCategory, @itemCategory = @itemCategory, @supplier = @supplier, @city = @city, @pageNumber = @pageNumber, @pageSize = @pageSize

end;

go

--ItemAverage
create or alter procedure ItemAverage(
@product varchar(50) = null,
@supplier varchar(50) = null,
@supplierCategory varchar(50) = null,
@initDate date = null,
@lastDate date = null,
@customerCategory varchar(50) = null,
@itemCategory varchar(50) = null,
@city varchar(50) = null,
@pageNumber int = null,
@pageSize int = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)

set @ParameterDef = '@product varchar(50), @supplier varchar(50), @supplierCategory varchar(50), @initDate date, @lastDate date, @customerCategory varchar(50), @itemCategory varchar(50), @city varchar(50), @pageNumber int, @pageSize int'
set @query = N'select CustomerCategoryName, StockItemName, PERCENTILE_CONT(1.0) WITHIN GROUP (ORDER BY count(StockItemName)) OVER (PARTITION BY StockItemName) Average
from Warehouse.StockGroups wsg
inner join Warehouse.StockItemStockGroups wsisg
on wsisg.StockGroupID = wsg.StockGroupID
inner join Warehouse.StockItems wsi
on wsi.StockItemID = wsisg.StockItemID
inner join Sales.InvoiceLines sil
on sil.StockItemID = wsisg.StockItemID
inner join Sales.Invoices si
on si.InvoiceID = sil.InvoiceID
inner join Purchasing.Suppliers ps
on ps.SupplierID = wsi.SupplierID
inner join Purchasing.SupplierCategories psc
on psc.SupplierCategoryID = ps.SupplierCategoryID
inner join Sales.Customers sc
on si.CustomerID = sc.CustomerID
inner join Sales.CustomerCategories scc
on scc.CustomerCategoryID = sc.CustomerCategoryID
inner join Application.Cities aci
on aci.CityID = sc.DeliveryCityID'

if @supplier is not null
	set @query = @query + ' and ps.SupplierName like ''%''+@supplier+''%'''

if @supplierCategory is not null
	set @query = @query + ' and psc.SupplierCategoryName like ''%''+@supplierCategory+''%'''

if @customerCategory is not null
	set @query = @query + ' and scc.CustomerCategoryName like ''%''+@customerCategory+''%'''

if @product is not null
	set @query = @query + ' and sil.Description like ''%''+@product+''%'''

if @itemCategory is not null
	set @query = @query + ' and wsg.StockGroupName like ''%''+@itemCategory+''%'''

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (InvoiceDate >= @initDate and InvoiceDate <= @lastDate)'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and InvoiceDate = @initDate'

if @city is not null
	set @query = @query + ' and CityName like ''%''+@city+''%'''

set @query = @query + ' group by CustomerCategoryName, StockItemName
order by CustomerCategoryName'

if @pageNumber is not null and @pageSize is not null
	set @query = @query + ' OFFSET @PageSize * (@PageNumber - 1) ROWS FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE)'

exec sp_executesql @query, @ParameterDef, @product = @product, @supplierCategory = @supplierCategory, @initDate = @initDate, @lastDate = @lastDate, @customerCategory = @customerCategory, @itemCategory = @itemCategory, @supplier = @supplier, @city = @city, @pageNumber = @pageNumber, @pageSize = @pageSize

end;

go
--ItemSupplier
create or alter procedure ProveedoresProductos(
@product varchar(50) = null,
@supplier varchar(50) = null,
@supplierCategory varchar(50) = null,
@initDate date  = null,
@lastDate date  = null,
@itemCategory varchar(50)  = null,
@customerCategory varchar(50) = null,	
@city varchar(50) = null)

as
begin

declare @ParameterDef nvarchar(500)
declare @query nvarchar(max)
declare @query2 nvarchar(max)
set @query2 = ' group by su.SupplierID,SupplierName,pol.Description,YEAR(OrderDate)) x'
set @ParameterDef = '@product varchar(50), @supplierCategory varchar(50), @initDate date, @lastDate date, @supplier varchar(50), @itemCategory varchar(50), @customerCategory varchar(50),@city varchar(50)'
set @query ='
select x.SupplierID ID, x.SupplierName nombreProveedor,x.year year,max(x.Description) ProductoMasVendido, 
MAX(x.cantidad) CantidadDeVentas
from(select su.SupplierID, SupplierName, pol.Description,YEAR(OrderDate) year,count(*) cantidad from Purchasing.Suppliers su
inner join Purchasing.PurchaseOrders po on su.SupplierID=po.SupplierID
inner join Purchasing.PurchaseOrderLines pol on po.PurchaseOrderID=pol.PurchaseOrderID
inner join Warehouse.StockItems si on pol.StockItemID= si.StockItemID
inner join Warehouse.StockItemStockGroups sig on si.StockItemID = sig.StockItemID
inner join Warehouse.StockGroups sg on sg.StockGroupID = sig.StockGroupID
inner join Purchasing.SupplierCategories sc on sc.SupplierCategoryID=su.SupplierCategoryID
inner join Sales.InvoiceLines sil on sil.StockItemID= si.StockItemID
inner join sales.Invoices sin on sin.InvoiceID=sil.InvoiceID
inner join sales.Customers scu on sin.CustomerID=scu.CustomerID
inner join sales.CustomerCategories scc on scc.CustomerCategoryID =scu.CustomerCategoryID
inner join Application.Cities aci on aci.CityID= scu.DeliveryCityID
where 1 = 1 '


if @supplier is not null
	set @query = @query + ' and SupplierName like ''%''+@supplier+''%'''

if @supplierCategory is not null
	set @query = @query + ' and SupplierCategoryName like ''%''+@supplierCategory+''%'''

if @product is not null
	set @query = @query + ' and pol.Description like ''%''+@product+''%'''

if @itemCategory is not null
	set @query = @query + 'and  StockGroupName like ''%''+@itemCategory+''%'''

if @initDate is not null and @lastDate is not null
	set @query = @query + ' and (OrderDate >= @initDate and OrderDate <= @lastDate)'

if @initDate is not null and @lastDate is null
	set @query = @query + ' and (OrderDate = @initDate)'

if @city is not null
	set @query = @query + ' and CityName like ''%''+@city+''%'''

if @customerCategory is not null
	set @query = @query + ' and scc.CustomerCategoryName like ''%''+@customerCategory+''%'''

set @query = @query + @query2 + ' group by x.SupplierName,x.year,x.SupplierID
	order by year, CantidadDeVentas desc;'
	print @query

exec sp_executesql @query, @ParameterDef, @product = @product, @supplierCategory = @supplierCategory, @initDate = @initDate, @lastDate = @lastDate, @itemCategory = @itemCategory, @supplier = @supplier,@city = @city,@customerCategory = @customerCategory

end;


