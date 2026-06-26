const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config();

mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/fitguard')
  .then(async () => {
    const RecoveryProtocol = require('./src/models/RecoveryProtocol');
    const Challenge = require('./src/models/Challenge');
    
    // Migrate RecoveryProtocol
    const protocols = await RecoveryProtocol.find({});
    let pMigrated = 0;
    for (const p of protocols) {
      let changed = false;
      p.phases.forEach(phase => {
        const newEx = [];
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
        await RecoveryProtocol.updateOne({ _id: p._id }, { phases: p.phases });
        pMigrated++;
      }
    }

    // Migrate Challenge
    const challenges = await Challenge.find({});
    let cMigrated = 0;
    for (const c of challenges) {
      let changed = false;
      c.generatedPlan.forEach(day => {
        if (day.task && day.exercises.length === 0 && typeof day.task === 'string') {
           day.exercises.push({ title: day.task, description: 'Migrated task', completed: day.completed });
           changed = true;
        }
      });
      if (changed) {
        await Challenge.updateOne({ _id: c._id }, { generatedPlan: c.generatedPlan });
        cMigrated++;
      }
    }
    
    console.log(`Migrated ${pMigrated} protocols and ${cMigrated} challenges.`);
    process.exit(0);
  });
