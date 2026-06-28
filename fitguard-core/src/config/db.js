const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');

let mongoServer;

const connectDB = async () => {
  try {
    let mongoURI = process.env.MONGO_URI || 'mongodb://localhost:27017/fitguard';
    
    if (process.env.USE_MEMORY_DB === 'true') {
      mongoServer = await MongoMemoryServer.create();
      mongoURI = mongoServer.getUri();
      console.log(`[Database Connection]: Using MongoMemoryServer at ${mongoURI}`);
      const conn = await mongoose.connect(mongoURI);
      console.log(`[Database Connection]: Connected to MongoDB at host ${conn.connection.host}`);
      return;
    }

    try {
      const options = process.env.NODE_ENV === 'production' ? {} : { serverSelectionTimeoutMS: 2000 };
      const conn = await mongoose.connect(mongoURI, options);
      console.log(`[Database Connection]: Connected to MongoDB at host ${conn.connection.host}`);
    } catch (err) {
      console.log(`[Database Connection Warning]: Standard connection failed (${err.message}).`);
      if (process.env.NODE_ENV === 'production') {
        console.error(`[Database Connection Error]: Cannot fallback to MongoMemoryServer in production. Exiting.`);
        process.exit(1);
      }
      console.log(`[Database Connection]: Automatically falling back to MongoMemoryServer for development...`);
      mongoServer = await MongoMemoryServer.create();
      mongoURI = mongoServer.getUri();
      const conn = await mongoose.connect(mongoURI);
      console.log(`[Database Connection]: Connected to fallback Memory MongoDB at host ${conn.connection.host}`);
    }
  } catch (error) {
    console.error(`[Database Connection Failure]: ${error.message}`);
    process.exit(1);
  }
};

module.exports = connectDB;
