const express = require('express');
const config = require('..\\config\\DBconfig');
const router = express.Router();

/*
http://serverAddress:3000/invoices/all
request for all invoices based on the filter
*/
router.get('/all',(req,res) =>
{
	getInvoices(req,res);

});

/*
http://serverAddress:3000/invoices/single
request for an invoice
*/
router.get('/single',(req,res) =>
{
	getInvoice(req,res);

});

/*
http://serverAddress:3000/invoices/total
request for the invoice total
*/
router.get('/total',(req,res) =>
{
	getInvoiceTotal(req,res);

});

//request to the sql server for all invoices for the customer based on the filter
function getInvoices(req,res){
	var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    request.input("customerID",req.query.customerID);

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
        request.execute('basicClientInvoice',(err,recordsets) => {
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

//request to the sql server for an invoice for the customer
function getInvoice(req,res){
	var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

	// inputs for the stored procedure
    request.input("invoiceID",req.query.invoiceID);

    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        // request stored procedure resutls
        request.execute('completeClientInvoice',(err,recordsets) => {
            if(err){
                console.log(err);
            }
            else{
                result = recordsets.recordset;
                res.send({result});
            }
        });
    });
}

//request to the sql server for the invoice total for the customer
function getInvoiceTotal(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

	// inputs for the stored procedure
    request.input("invoiceID",req.query.invoiceID);

    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        // request stored procedure resutls
        request.execute('invoiceTotal',(err,recordsets) => {
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
