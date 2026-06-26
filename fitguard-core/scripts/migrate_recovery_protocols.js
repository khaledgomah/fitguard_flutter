require('dotenv').config();
const mongoose = require('mongoose');
const RecoveryProtocol = require('../src/models/RecoveryProtocol');

// To run: MONGODB_URI=your_uri node scripts/migrate_recovery_protocols.js

async function runMigration() {
  const MONGO_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/fitguard';
  console.log(`Connecting to MongoDB at: ${MONGO_URI}`);
  
  try {
    await mongoose.connect(MONGO_URI);
    console.log('Connected.');
    
    const legacyQuery = {
      $or: [
        { goal: { $exists: false } },
        { target: { $exists: false } },
        { endDate: { $exists: false } },
        { goal: null }
      ]
    };
    
    const legacyProtocols = await RecoveryProtocol.find(legacyQuery);
    const count = legacyProtocols.length;
    console.log(`Found ${count} legacy protocols requiring migration.`);
    
    let migrated = 0;
    
    for (const p of legacyProtocols) {
      try {
        const startDate = p.startDate || new Date();
        const totalDays = p.phases.reduce((sum, ph) => sum + (ph.durationDays || 0), 0);
        const endDate = new Date(startDate.getTime() + totalDays * 24 * 60 * 60 * 1000);
        
        p.goal = 'Return to baseline performance';
        p.target = 'Restore foundational mobility';
        p.endDate = endDate;
        
        await p.save();
        migrated++;
      } catch (err) {
        console.error(`Failed to migrate protocol ${p._id}:`, err);
      }
    }
    
    console.log(`Migration complete. Successfully migrated ${migrated}/${count} protocols.`);
  } catch (err) {
    console.error('Migration failed:', err);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB.');
    process.exit(0);
  }
}

runMigration();
