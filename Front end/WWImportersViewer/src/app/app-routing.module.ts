import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { MainComponent } from './components/main/main.component';
import { CustomersComponent } from './components/customers/customers.component';
import { CustomerComponent } from './components/customer/customer.component';
import { InvoicesComponent } from './components/invoices/invoices.component';
import { Top5Component } from './components/top5/top5.component';
import { Top3Component } from './components/top3/top3.component';
import { MonthItemSalesComponent } from './components/month-item-sales/month-item-sales.component';
import { ItemAverageComponent } from './components/item-average/item-average.component';
import { ItemSuppliersComponent } from './components/item-suppliers/item-suppliers.component';
import { SuppliersComponent } from './components/suppliers/suppliers.component';
import{SupplierComponent} from './components/supplier/supplier.component';

const routes: Routes = [
  { path: '', redirectTo: '/customers', pathMatch: 'full' },
  { path: 'customers', component:CustomersComponent },
  { path: 'customer/:customerID', component:CustomerComponent },
  { path: 'invoices/:customerID', component:InvoicesComponent },
  { path: 'top5', component:Top5Component },
  { path: 'top3', component:Top3Component },
  { path: 'monthSales', component:MonthItemSalesComponent },
  { path: 'itemAverage', component:ItemAverageComponent },
  { path: 'itemSuppliers', component:ItemSuppliersComponent },
  { path: 'suppliers', component:SuppliersComponent },
  { path: 'supplier/:supplierID', component:SupplierComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
