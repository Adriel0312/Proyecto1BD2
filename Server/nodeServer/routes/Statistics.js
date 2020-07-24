const express = require('express');
const config = require('..\\config\\DBconfig');
const router = express.Router();

/*
http://serverAddress:3000/statistic/MonthItemSales
request for the month with most sales per item and item category based on the filter
*/
router.get('/MonthItemSales',(req,res) =>
{
	MonthItemSales(req,res);

});

/*
http://serverAddress:3000/statistic/ItemAverage
request for the average sales per item based on the filter
*/
router.get('/ItemAverage',(req,res) =>
{
    ItemAverage(req,res);

});

/*
http://serverAddress:3000/statistic/ItemSuppliers
request for the best sales per item for suppliers based on the filter
*/
router.get('/ItemSuppliers',(req,res) =>
{
    SupplierItems(req,res);

});

//request to the sql server for the month with most sales per item and item category based on the filter
function MonthItemSales(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    if (req.query.supplier != undefined){
        request.input("supplier",req.query.supplier);
    }

    if (req.query.supplierCategory != undefined){
        request.input("supplierCategory",req.query.supplierCategory);
    }

    if (req.query.customerCategory != undefined){
        request.input("customerCategory",req.query.customerCategory);
    }

    if (req.query.product != undefined){
        request.input("product",req.query.product);
    }

    if (req.query.itemCategory != undefined){
        request.input("itemCategory",req.query.itemCategory);
    }

    if (req.query.city != undefined){
        request.input("city",req.query.city);
    }

    if (req.query.initDate != undefined){
        request.input("initDate", req.query.initDate);
    }

    if (req.query.lastDate != undefined){
        request.input("lastDate", req.query.lastDate);
    }

		if (req.query.pageNumber != undefined){
        request.input("pageNumber", req.query.pageNumber);
    }

    if (req.query.pageSize != undefined){
        request.input("pageSize", req.query.pageSize);
    }

    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        // request stored procedure resutls
        request.execute('BestMonthItemSales',(err,recordsets) => {
            if(err){
                console.log(err);
            }
            else{
                result = recordsets.recordset;
                res.send({result});
            }
            conn.close();
        });
    });
}

//request to the sql server for the average sales per item based on the filter
function ItemAverage(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    if (req.query.supplier != undefined){
        request.input("supplier",req.query.supplier);
    }

    if (req.query.supplierCategory != undefined){
        request.input("supplierCategory",req.query.supplierCategory);
    }

    if (req.query.customerCategory != undefined){
        request.input("customerCategory",req.query.customerCategory);
    }

    if (req.query.product != undefined){
        request.input("product",req.query.product);
    }

    if (req.query.itemCategory != undefined){
        request.input("itemCategory",req.query.itemCategory);
    }

    if (req.query.city != undefined){
        request.input("city",req.query.city);
    }

    if (req.query.initDate != undefined){
        request.input("initDate", sql.DateTime, req.query.initDate);
    }

    if (req.query.lastDate != undefined){
        request.input("lastDate", sql.DateTime, req.query.lastDate);
    }

		if (req.query.pageNumber != undefined){
        request.input("pageNumber", req.query.pageNumber);
    }

    if (req.query.pageSize != undefined){
        request.input("pageSize", req.query.pageSize);
    }

    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }


        // request stored procedure resutls
        request.execute('ItemAverage',(err,recordsets) => {
            if(err){
                console.log(err);
            }
            else{
                result = recordsets.recordset;
                res.send({result});
            }
            conn.close();
        });
    });
}

//request to the sql server for the best sales per item for suppliers based on the filter
function SupplierItems(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    if (req.query.supplier != undefined){
        request.input("supplier",req.query.supplier);
    }

    if (req.query.supplierCategory != undefined){
        request.input("supplierCategory",req.query.supplierCategory);
    }

    if (req.query.customerCategory != undefined){
        request.input("customerCategory",req.query.customerCategory);
    }

    if (req.query.product != undefined){
        request.input("product",req.query.product);
    }

    if (req.query.itemCategory != undefined){
        request.input("itemCategory",req.query.itemCategory);
    }

    if (req.query.city != undefined){
        request.input("city",req.query.city);
    }


    if (req.query.initDate != undefined){
        request.input("initDate", sql.DateTime, req.query.initDate);
    }

    if (req.query.lastDate != undefined){
        request.input("lastDate", sql.DateTime, req.query.lastDate);
    }


	
    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }


        // request stored procedure resutls
        request.execute('ProveedoresProductos',(err,recordsets) => {
            if(err){
                console.log(err);
            }
            else{
                result = recordsets.recordset;
                res.send({result});
            }
            conn.close();
        });
    });
}

module.exports = router
