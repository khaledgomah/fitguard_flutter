const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/fitguard')
  .then(async () => {
    const db = mongoose.connection.db;
    
    // Migrate RecoveryProtocol
    const protocols = await db.collection('recoveryprotocols').find({}).toArray();
    let pMigrated = 0;
    for (const p of protocols) {
      let changed = false;
      if (!p.phases) continue;
      p.phases.forEach(phase => {
        const newEx = [];
        if (!phase.exercises) return;
        phase.exercises.forEach(ex => {
          if (typeof ex === 'string') {
            newEx.push({ title: ex, completed: false });
            changed = true;
          } else {
            newEx.push(ex);
          }
        });
        if (changed) phase.exercises = newEx;
      });
      if (changed) {
        await db.collection('recoveryprotocols').updateOne({ _id: p._id }, { $set: { phases: p.phases } });
        pMigrated++;
      }
    }

    // Migrate Challenge
    const challenges = await db.collection('challenges').find({}).toArray();
    let cMigrated = 0;
    for (const c of challenges) {
      let changed = false;
      if (!c.generatedPlan) continue;
      c.generatedPlan.forEach(day => {
        if (!day.exercises) day.exercises = [];
        if (day.task && day.exercises.length === 0 && typeof day.task === 'string') {
           day.exercises.push({ title: day.task, description: 'Migrated task', completed: day.completed || false });
           changed = true;
        }
      });
      if (changed) {
        await db.collection('challenges').updateOne({ _id: c._id }, { $set: { generatedPlan: c.generatedPlan } });
        cMigrated++;
      }
    }
    
    console.log(`Migrated ${pMigrated} protocols and ${cMigrated} challenges.`);
    process.exit(0);
  });
