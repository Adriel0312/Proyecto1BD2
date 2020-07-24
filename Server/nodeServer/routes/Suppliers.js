const express = require('express');
const config = require('..\\config\\DBconfig');
const router = express.Router();

/*
http://serverAddress:3000/suppliers/all
request for all suppliers based on the filter
*/
router.get('/all',(req,res) =>
{
	getSuppliers(req,res);

});

/*
http://serverAddress:3000/suppliers/single
request for a supplier based on the filter
*/
router.get('/single',(req,res) =>
{
    getSupplier(req,res);

});

//request to the sql server for all suppliers based on the filter
function getSuppliers(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    if (req.query.NombreProveedor != undefined){
        request.input("NombreProveedor",req.query.NombreProveedor);
    }

    if (req.query.CategoriaProveedor != undefined){
        request.input("CategoriaProveedor",req.query.CategoriaProveedor);
    }

    if (req.query.DireccionProveedor != undefined){
        request.input("DireccionProveedor",req.query.DireccionProveedor);
    }

    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        // request stored procedure resutls
        request.execute('proveedoresBasicosFiltro',(err,recordsets) => {
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

//request to the sql server for a supplier based on the filter
function getSupplier(req,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var request = new sql.Request(conn);

    // inputs for the stored procedure
    request.input("idProveedor",req.query.idProveedor);
    
    // conection to sql server
    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        // request stored procedure resutls
        request.execute('proveedoresFullData',(err,recordsets) => {
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