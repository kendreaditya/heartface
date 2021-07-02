const express = require('express');
const morgan = require('morgan');
const helmet = require('helmet');
const mongoose = require('mongoose');
const connectDB = require('./db');
const bodyParser = require('body-parser');
const dashboard = require('./routes/api/dashboard');
const course = require('./routes/api/course');

const app = express();
const port = 5000;

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Methods', 'POST, GET, PUT, OPTIONS, DELETE');
  next();
});

app.use(morgan("dev"));
app.use(helmet());

connectDB();

app.use('/api/v1/', prediction);

app.listen(port, () => console.log(`API Server listening on port ${port}`));