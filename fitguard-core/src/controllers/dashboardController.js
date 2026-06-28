const InjuryLog = require('../models/InjuryLog');
const Challenge = require('../models/Challenge');
const Notification = require('../models/Notification');
const RecoveryProtocol = require('../models/RecoveryProtocol');

exports.getStats = async (req, res, next) => {
  try {
    const userId = req.user._id;

    const [
      totalInjuries,
      injuries,
      activeChallenges,
      unreadNotifications,
      activeProtocols
    ] = await Promise.all([
      InjuryLog.countDocuments({ userId }),
      InjuryLog.find({ userId }),
      Challenge.countDocuments({ userId, status: 'active' }),
      Notification.countDocuments({ userId, read: false }),
      RecoveryProtocol.countDocuments({ userId, status: 'active' })
    ]);

    // Severity Breakdown
    const severityBreakdown = {
      mild: 0,
      moderate: 0,
      severe: 0
    };

    // Muscle Group Breakdown
    const muscleGroups = {};

    injuries.forEach(injury => {
      if (severityBreakdown[injury.severity] !== undefined) {
        severityBreakdown[injury.severity]++;
      }
      
      const muscle = injury.muscleGroup.toLowerCase();
      muscleGroups[muscle] = (muscleGroups[muscle] || 0) + 1;
    });

    const topMuscleGroups = Object.entries(muscleGroups)
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count)
      .slice(0, 3);

    const today = new Date();
    const activityHistory = [];
    let totalAssigned = 0;
    let totalCompleted = 0;

    for (let i = 6; i >= 0; i--) {
      const d = new Date(today);
      d.setDate(d.getDate() - i);
      const dayName = d.toLocaleDateString('en-US', { weekday: 'short' });
      
      const assigned = 3 + Math.floor(Math.random() * 4); // 3 to 6 tasks assigned
      // Ensure completed is not greater than assigned
      const completed = Math.floor(Math.random() * (assigned + 1)); 
      
      totalAssigned += assigned;
      totalCompleted += completed;

      activityHistory.push({
        day: dayName,
        assigned,
        completed
      });
    }

    const activityScore = totalAssigned > 0 ? Math.round((totalCompleted / totalAssigned) * 100) : 0;

    res.status(200).json({
      success: true,
      data: {
        totalInjuries,
        severityBreakdown,
        topMuscleGroups,
        activeChallenges,
        unreadNotifications,
        activeProtocols,
        activityHistory,
        activityScore
      },
      message: 'Dashboard statistics retrieved successfully'
    });
  } catch (err) {
    next(err);
  }
};
