const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
const User = require('./src/models/User');
const Challenge = require('./src/models/Challenge');
const challengeController = require('./src/controllers/challengeController');
const RecoveryProtocol = require('./src/models/RecoveryProtocol');
const InjuryLog = require('./src/models/InjuryLog');
const recoveryController = require('./src/controllers/recoveryController');

async function runEvidence() {
  const mongoServer = await MongoMemoryServer.create();
  await mongoose.connect(mongoServer.getUri());

  const user = await User.create({ name: 'Evidence User', email: 'evidence@test.com', password: 'password', sport: 'Soccer' });

  // 1. Challenge Lifecycle
  const mockReqGenChallenge = { user, body: { difficulty: 'beginner' } };
  const mockResGenChallenge = { status: () => mockResGenChallenge, json: (data) => data };
  
  const genChallengeResult = await challengeController.generateChallenge(mockReqGenChallenge, mockResGenChallenge, console.error);
  
  console.log("\n--- CHALLENGE GENERATED ---");
  const challengeBefore = await Challenge.findById(genChallengeResult.data._id);
  console.log(JSON.stringify(challengeBefore, null, 2));

  // Complete exercise
  const day1 = challengeBefore.generatedPlan[0];
  const ex1 = day1.exercises[0];
  const mockReqToggleEx = { user, params: { id: challengeBefore._id, dayNumber: day1.day, exerciseId: ex1._id } };
  await challengeController.toggleExercise(mockReqToggleEx, mockResGenChallenge, console.error);

  // Complete Day
  const mockReqCompleteDay = { user, params: { id: challengeBefore._id, dayNumber: day1.day } };
  await challengeController.completeDay(mockReqCompleteDay, mockResGenChallenge, console.error);

  // Complete entire challenge (hack to fast forward to day 30)
  challengeBefore.currentDay = 30;
  await challengeBefore.save();
  const mockReqCompleteDay30 = { user, params: { id: challengeBefore._id, dayNumber: 30 } };
  await challengeController.completeDay(mockReqCompleteDay30, mockResGenChallenge, console.error);

  console.log("\n--- CHALLENGE COMPLETED ---");
  const challengeAfter = await Challenge.findById(genChallengeResult.data._id);
  console.log(JSON.stringify(challengeAfter, null, 2));


  // 2. Recovery Lifecycle
  const injury = await InjuryLog.create({ userId: user._id, muscleGroup: 'Knee', injuryType: 'Sprain', severity: 5 });
  
  const mockReqGenRecovery = { user, body: { injuryLogId: injury._id } };
  const genRecoveryResult = await recoveryController.generateProtocol(mockReqGenRecovery, mockResGenChallenge, console.error);

  console.log("\n--- RECOVERY GENERATED ---");
  const recoveryBefore = await RecoveryProtocol.findById(genRecoveryResult.data._id);
  console.log(JSON.stringify(recoveryBefore, null, 2));

  // Toggle Exercise
  const phase1 = recoveryBefore.phases[0];
  const rex1 = phase1.exercises[0];
  const mockReqToggleRecEx = { user, params: { id: recoveryBefore._id, phaseNumber: phase1.phaseNumber, exerciseId: rex1._id } };
  await recoveryController.toggleExercise(mockReqToggleRecEx, mockResGenChallenge, console.error);

  // Complete Phase
  const mockReqCompletePhase = { user, params: { id: recoveryBefore._id, phaseNumber: phase1.phaseNumber } };
  await recoveryController.completePhase(mockReqCompletePhase, mockResGenChallenge, console.error);

  // Fast forward to complete recovery
  recoveryBefore.currentPhase = recoveryBefore.phases[recoveryBefore.phases.length - 1].phaseNumber;
  await recoveryBefore.save();
  const mockReqCompleteFinalPhase = { user, params: { id: recoveryBefore._id, phaseNumber: recoveryBefore.currentPhase } };
  await recoveryController.completePhase(mockReqCompleteFinalPhase, mockResGenChallenge, console.error);

  console.log("\n--- RECOVERY COMPLETED ---");
  const recoveryAfter = await RecoveryProtocol.findById(genRecoveryResult.data._id);
  console.log(JSON.stringify(recoveryAfter, null, 2));

  process.exit(0);
}

runEvidence();
