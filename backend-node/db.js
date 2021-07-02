const mongoose = require("mongoose")
const URI = "mongodb+srv://kendreaditya:PASSWORD@cluster0.4kruj.mongodb.net/doordashpracticedb?retryWrites=true&w=majority";


const connectDB = async () => {
    await mongoose.connect(URI, {
        useUnifiedTopology: true,
        useNewUrlParser: true
    });
    console.log("MongoDB successfully connected!")
}

module.exports = connectDB;