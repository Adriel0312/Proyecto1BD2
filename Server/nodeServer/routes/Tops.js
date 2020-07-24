const express = require('express');
const config = require('..\\config\\DBconfig');
const router = express.Router();

/*
http://serverAddress:3000/top/CountrySales
request for the top 5 CountrySales based on the filter
*/
router.get('/CountrySales',(req,res) =>
{
	getTop5(req,res);
});

/*
http://serverAddress:3000/top/ItemSales
request for the top3 ItemSales based on the filter
*/
router.get('/ItemSales',(req,res) =>
{
    getTop3(req,res)
});

//request to the sql server for the top 5 CountrySales based on the filter
function getTop5(req,res){
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
        request.input("country",req.query.city);
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
        request.execute('Top5CountrySales',(err,recordsets) => {
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

//request to the sql server for the top3 ItemSales based on the filter
function getTop3(req,res){
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
        request.execute('Top3ItemSales',(err,recordsets) => {
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
