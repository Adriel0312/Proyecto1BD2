const express = require('express');
const config = require('C:\\Users\\Medaka Gremory\\Projects\\BDII-PY01\\nodeServer\\config\\DBconfig');

function request(procedure,res){
    var sql = require("mssql");
    var conn = new sql.ConnectionPool(config);
    var req = new sql.Request(conn);

    conn.connect(function(err){
        if (err){
            console.log("no se pudo conectar");
            console.log(err);
            return;
        }

        req.execute(procedure,function(err,recordset){
            if(err){
                console.log(err);
            }
            else{
                result = recordset.recordset;
                res.send({result});
            }
            conn.close();
        });
    });
} 

module.exports = request