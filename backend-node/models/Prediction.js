const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const Prediction = new Schema({
    id: String,
    date_created: String,
    prediction: String,
    samples: Array
})

module.exports = mongoose.model('Prediction', Prediction);