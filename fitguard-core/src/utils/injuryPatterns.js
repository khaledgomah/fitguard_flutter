/**
 * Aggregates injury logs to build the AI context object.
 * 
 * @param {Object} user 
 * @param {string} difficulty 
 * @param {Array} injuryLogs 
 * @returns {Object} 
 */
function getInjuryAIContext(user, difficulty, injuryLogs) {
  const muscleGroupsCount = {};
  const activeInjuries = [];
  const injuryHistory = [];

  injuryLogs.forEach(log => {
    const muscle = (log.muscleGroup || '').trim().toLowerCase();

    injuryHistory.push({
      muscleGroup: log.muscleGroup,
      injuryType: log.injuryType,
      severity: log.severity,
      dateOccurred: log.dateOccurred,
      recoveryStatus: log.recoveryStatus,
      notes: log.notes
    });

    if (muscle) {
      muscleGroupsCount[muscle] = (muscleGroupsCount[muscle] || 0) + 1;
    }

    if (log.recoveryStatus === 'active') {
      activeInjuries.push({
        muscleGroup: log.muscleGroup,
        injuryType: log.injuryType,
        severity: log.severity,
        dateOccurred: log.dateOccurred,
        notes: log.notes
      });
    }
  });

  const recurringInjuries = Object.keys(muscleGroupsCount)
    .filter(muscle => muscleGroupsCount[muscle] >= 2)
    .map(muscle => ({
      muscleGroup: muscle,
      injuryCount: muscleGroupsCount[muscle]
    }));

  return {
    sport: user.sport,
    difficulty: difficulty || 'intermediate',
    injuryHistory,
    recurringInjuries,
    activeInjuries
  };
}

module.exports = {
  getInjuryAIContext
};
