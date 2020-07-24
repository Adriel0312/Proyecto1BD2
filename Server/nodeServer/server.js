const express = require('express');
const config = require('..\\nodeServer\\config\\Serverconfig');
const invoices = require('..\\nodeServer\\routes\\Invoices')
const customers = require('..\\nodeServer\\routes\\Customers')
const suppliers = require('..\\nodeServer\\routes\\Suppliers')
const tops = require('..\\nodeServer\\routes\\Tops')
const statistic = require('..\\nodeServer\\routes\\Statistics')

const app = express();

app.use(function (req, res, next) {
res.setHeader('Access-Control-Allow-Origin', '*');
res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
res.setHeader('Access-Control-Allow-Credentials', true);
next();
});

//redirects to the file that manages that data
app.use('/customers',customers);
app.use('/invoices',invoices);
app.use('/suppliers',suppliers);

app.use('/top',tops);

app.use('/statistic',statistic);

// Index Route
app.get('/', (req, res) => {
  res.json({"message":"Invalid Endpoint"});
});

// Start server listener
app.listen(config.port,() => {console.log('Server is running on port '+config.port);});
