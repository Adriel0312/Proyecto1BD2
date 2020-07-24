const express = require('express');
const config = require('..\\config\\DBconfig');
const router = express.Router();

/*
http://serverAddress:3000/customers/all
request for all customers based on the filter
*/
router.get('/all',(req,res) =>
{
	getCustomers(req,res);

});

/*
http://serverAddress:3000/customers/single
request for a customer based on the filter
*/
router.get('/single',(req,res) =>
{
    getCustomer(req,res);

});

//request to the sql server for all customers based on the filter
function getCustomers(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    if (req.query.customerName != undefined){
        request.input("customerName",req.query.customerName);
    }

    if (req.query.category != undefined){
        request.input("category",req.query.category);
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
        request.execute('basicClientData',(err,recordsets) => {
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

//request to the sql server for a customer based on the filter
function getCustomer(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    request.input("customerID",req.query.customerID);

     // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        // request stored procedure resutls
        request.execute('completeClientData',(err,recordsets) => {
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
