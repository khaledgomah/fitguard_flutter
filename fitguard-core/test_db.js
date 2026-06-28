const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/fitguard')
  .then(async () => {
    console.log("Connected to DB");
    const RecoveryProtocol = require('./src/models/RecoveryProtocol');
    const Challenge = require('./src/models/Challenge');
    
    // fetch one of each to see if we get cast errors
    try {
      const p = await RecoveryProtocol.findOne({});
      console.log("Protocol:", p ? "Found" : "None");
      const c = await Challenge.findOne({});
      console.log("Challenge:", c ? "Found" : "None");
    } catch(err) {
      console.error("Cast Error:", err.message);
    }
    
    process.exit(0);
  });
