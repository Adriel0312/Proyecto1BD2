

use WideWorldImporters;

go
exec ProveedoresProductos ;


exec ProveedoresProductos @supplier = 'L',@supplierCategory ='O',@initDate='2013',@lastDate='2015',@city='L' ;


exec Top3ItemSales @supplier = 'L',@supplierCategory ='O',@initDate='2013',@lastDate='2015',@city='L';


exec Top5CountrySales;

exec Top5CountrySales  @supplier = 'L',@supplierCategory ='O',@initDate='2013',@lastDate='2015',@country='U';

exec BestMonthItemSales;

exec BestMonthItemSales  @supplier = 'L',@supplierCategory ='O',@initDate='2013',@lastDate='2015',@city='U';

exec basicClientData;
exec basicClientData @customerName= 'L', @category ='e';

exec basicClientInvoice @customerID=8;
exec completeClientData @customerID= 2;
exec completeClientInvoice @invoiceID= 1;
exec invoiceTotal @invoiceID= 1;

exec ItemAverage;
exec ItemAverage @supplier = 'L',@supplierCategory ='O',@initDate='2013',@lastDate='2015',@city='U';

exec proveedoresBasicosFiltro @NombreProveedor ='A datum Cor';
exec  proveedoresFullData @idProveedor= 1;

exec ProveedoresProductos @supplier = 'L',@supplierCategory ='O',@initDate='2013',@lastDate='2015',@city='U';


