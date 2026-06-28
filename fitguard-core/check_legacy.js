const mongoose = require('mongoose');
const RecoveryProtocol = require('./src/models/RecoveryProtocol');
const dotenv = require('dotenv');

dotenv.config();
const MONGO_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/fitguard';

async function run() {
  await mongoose.connect(MONGO_URI);
  const legacyCount = await RecoveryProtocol.countDocuments({
    $or: [
      { goal: { $exists: false } },
      { target: { $exists: false } },
      { endDate: { $exists: false } }
    ]
  });
  console.log(`Legacy records found: ${legacyCount}`);

  const allProtocols = await RecoveryProtocol.find({});
  console.log(`Total records: ${allProtocols.length}`);

  process.exit(0);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
