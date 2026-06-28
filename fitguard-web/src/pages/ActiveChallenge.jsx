import { useState } from 'react';
import { useChallengeStore } from '../store/challengeStore';
import { Link, useNavigate } from 'react-router-dom';

export default function ActiveChallenge() {
  const { activeChallenge, completeDay, toggleChallengeExercise, abandonChallenge } = useChallengeStore();
  const navigate = useNavigate();
  const [view, setView] = useState('dashboard'); // 'dashboard' | 'tasks'
  const [showAbandonModal, setShowAbandonModal] = useState(false);

  if (!activeChallenge) {
    return <div className="p-8 text-center">No active challenge found. <Link to="/challenges/generate" className="text-primary underline">Generate one</Link></div>;
  }

  const completedDaysCount = activeChallenge.generatedPlan.filter(d => d.completed).length;
  const currentDay = activeChallenge.generatedPlan.findIndex(d => !d.completed) + 1 || activeChallenge.generatedPlan.length;
  const planForToday = activeChallenge.generatedPlan.find(d => !d.completed) || activeChallenge.generatedPlan[activeChallenge.generatedPlan.length - 1];
  
  const handleCompleteDay = async () => {
    await completeDay(activeChallenge.id || activeChallenge._id, currentDay);
    if (currentDay === activeChallenge.generatedPlan.length) {
      navigate('/dashboard');
    }
  };

  const handleAbandonChallenge = async () => {
    await abandonChallenge(activeChallenge.id || activeChallenge._id);
    setShowAbandonModal(false);
  };
  
  const exercises = planForToday?.exercises || [];
  const completedExercisesCount = exercises.filter(ex => ex.completed).length;
  const totalExercises = exercises.length;
  const allExercisesCompleted = totalExercises > 0 ? completedExercisesCount === totalExercises : false;
  const totalDays = activeChallenge.generatedPlan.length;
  const progressPercentage = totalDays > 0 ? Math.round((completedDaysCount / totalDays) * 100) : 0;

  return (
    <div className="p-margin-mobile md:p-margin-desktop bg-surface-bright min-h-[calc(100vh-64px)] overflow-y-auto">
      
      {view === 'dashboard' ? (
        <div className="max-w-container-max mx-auto space-y-8">
          {/* Header Section */}
          <div className="flex flex-col md:flex-row justify-between items-start md:items-end gap-6 mb-8">
            <div className="w-full md:w-auto">
              <p className="font-label-md text-label-md text-secondary uppercase tracking-widest mb-1">AI Program Active</p>
              <h2 className="font-display-sm md:font-display-md text-display-sm md:text-display-md text-on-surface break-words">30-Day Resilience Challenge</h2>
            </div>
            <div className="flex flex-col sm:flex-row gap-3 w-full md:w-auto">
              <button onClick={() => setShowAbandonModal(true)} className="w-full sm:w-auto px-6 py-3 md:py-2 border border-error text-error font-label-md text-label-md rounded-full hover:bg-error-container transition-colors text-center">
                Abandon
              </button>
              <Link to={`/challenges/${activeChallenge.id || activeChallenge._id}`} className="w-full sm:w-auto px-6 py-3 md:py-2 border border-outline-variant text-on-surface font-label-md text-label-md rounded-full hover:bg-surface-container-low transition-colors text-center">
                View Guidelines
              </Link>
            </div>
          </div>

          {/* Dashboard Grid (Bento Style) */}
          <div className="grid grid-cols-12 gap-6">
            
            {/* Progress Overview Card (Spans 8 cols) */}
            <div className="col-span-12 lg:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-2xl p-6 md:p-8 flex flex-col md:flex-row items-center gap-8 shadow-sm w-full">
              {/* Circular Progress */}
              <div className="relative w-40 h-40 md:w-48 md:h-48 flex-shrink-0 mx-auto md:mx-0">
                <svg className="w-full h-full transform -rotate-90" viewBox="0 0 36 36">
                  {/* Background Circle */}
                  <path className="text-surface-container-highest stroke-current" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" strokeWidth="3"></path>
                  {/* Progress Circle - Note: adding style inline since keyframes are not in module */}
                  <path className="text-secondary-container stroke-current" style={{ strokeDasharray: `${progressPercentage}, 100`, transition: 'stroke-dasharray 1.5s ease-out' }} d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" strokeLinecap="round" strokeWidth="3"></path>
                </svg>
                <div className="absolute inset-0 flex flex-col items-center justify-center">
                  <span className="font-display-md text-display-md text-on-surface">{currentDay}</span>
                  <span className="font-label-md text-label-md text-on-surface-variant">/ {totalDays} Days</span>
                </div>
              </div>
              
              {/* Stats & Streak */}
              <div className="flex-1 space-y-6 w-full">
                <div>
                  <h3 className="font-headline-sm text-headline-sm text-on-surface mb-2">Phase {Math.ceil(currentDay / 10)}: {Math.ceil(currentDay / 10) === 1 ? 'Foundation' : Math.ceil(currentDay / 10) === 2 ? 'Adaptation' : 'Mastery'}</h3>
                  <p className="font-body-md text-body-md text-on-surface-variant">You are maintaining a strong recovery baseline. Biometric strain is optimal for current workload.</p>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 w-full">
                  <div className="bg-surface p-4 rounded-xl border border-outline-variant flex items-center gap-4">
                    <div className="w-12 h-12 rounded-full bg-tertiary-container/20 flex-shrink-0 flex items-center justify-center text-tertiary">
                      <span className="material-symbols-outlined text-[24px] select-none" aria-hidden="true" style={{ fontVariationSettings: "'FILL' 1" }}>local_fire_department</span>
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-label-md text-label-md text-on-surface-variant truncate">Current Streak</p>
                      <p className="font-headline-md text-headline-md text-on-surface truncate">{completedDaysCount} Days</p>
                    </div>
                  </div>
                  <div className="bg-surface p-4 rounded-xl border border-outline-variant flex items-center gap-4">
                    <div className="w-12 h-12 rounded-full bg-primary-container/20 flex-shrink-0 flex items-center justify-center text-primary">
                      <span className="material-symbols-outlined text-[24px] select-none" aria-hidden="true" style={{ fontVariationSettings: "'FILL' 1" }}>task_alt</span>
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-label-md text-label-md text-on-surface-variant truncate">Completion Rate</p>
                      <p className="font-headline-md text-headline-md text-on-surface truncate">{progressPercentage}%</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Today's Task Card (Spans 4 cols) */}
            <div className="col-span-12 lg:col-span-4 bg-secondary-fixed text-on-secondary-fixed rounded-2xl p-6 flex flex-col shadow-sm border border-secondary-fixed-dim">
              <div className="flex justify-between items-start gap-4 mb-6">
                <div className="flex-1">
                  <span className="inline-block px-3 py-1 bg-on-secondary-fixed text-secondary-fixed font-label-md text-label-md rounded-full mb-3">Day {currentDay}</span>
                  <h3 className="font-headline-md text-headline-md mb-1 break-words">{planForToday?.task || 'Rest Day'}</h3>
                  <p className="font-body-sm text-body-sm opacity-80">Difficulty: {planForToday?.difficulty}</p>
                </div>
                <span className="material-symbols-outlined text-[32px] opacity-50 flex-shrink-0 overflow-hidden whitespace-nowrap">fitness_center</span>
              </div>
              <div className="mt-auto space-y-4">
                <div className="flex items-center gap-3 text-sm">
                  <span className="material-symbols-outlined text-[20px]">vital_signs</span>
                  <span className="font-mono-data text-mono-data">{planForToday?.muscleGroups.join(', ') || 'General'}</span>
                </div>
                <button onClick={() => setView('tasks')} className="flex items-center justify-center w-full mt-4 py-3 bg-secondary text-on-secondary font-label-md text-label-md rounded-lg hover:opacity-90 transition-opacity">
                  Start Session
                </button>
              </div>
            </div>

            {/* 30-Day Grid (Spans 12 cols) */}
            <div className="col-span-12 bg-surface-container-lowest border border-outline-variant rounded-2xl p-8 shadow-sm">
              <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-6">
                <h3 className="font-headline-sm text-headline-sm text-on-surface">Journey Map</h3>
                <div className="flex flex-wrap gap-4 font-label-md text-label-md text-on-surface-variant">
                  <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-sm bg-primary flex-shrink-0"></div> Completed</div>
                  <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-sm bg-secondary-container flex-shrink-0"></div> Today</div>
                  <div className="flex items-center gap-2"><div className="w-3 h-3 rounded-sm bg-surface-container-highest flex-shrink-0"></div> Locked</div>
                </div>
              </div>
              {/* Grid */}
              <div className="grid grid-cols-4 sm:grid-cols-5 lg:grid-cols-10 gap-2 sm:gap-3">
                {activeChallenge.generatedPlan.map((dayObj, index) => {
                  const isCompleted = dayObj.completed;
                  const isToday = !isCompleted && currentDay === dayObj.day;
                  let bgClass = "bg-surface-container-highest opacity-60"; // Locked
                  if (isCompleted) bgClass = "bg-primary text-on-primary shadow-sm";
                  else if (isToday) bgClass = "bg-secondary-container text-on-secondary-container shadow-md scale-105 transform border border-secondary";
                  
                  return (
                    <div key={index} className={`flex flex-col items-center justify-center py-2 px-1 sm:p-3 rounded-lg transition-all ${bgClass} min-w-0`}>
                      <span className="font-label-sm sm:font-label-md text-label-sm sm:text-label-md mb-1">Day</span>
                      <span className="font-title-lg sm:font-headline-md text-title-lg sm:text-headline-md">{dayObj.day}</span>
                    </div>
                  );
                })}
              </div>
            </div>

          </div>
        </div>
      ) : (
        <div className="max-w-container-max mx-auto space-y-8">
          {/* Page Header */}
          <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
              <button onClick={() => setView('dashboard')} className="flex items-center text-secondary hover:underline font-label-md text-label-md mb-2">
                <span className="material-symbols-outlined text-[16px] mr-1">arrow_back</span>
                Back to Dashboard
              </button>
              <h1 className="font-display-md text-display-md text-on-surface">Daily Challenge</h1>
              <p className="font-body-lg text-body-lg text-on-surface-variant mt-1">Day {currentDay} of {totalDays}: {Math.ceil(currentDay / 10) === 1 ? 'Foundation' : Math.ceil(currentDay / 10) === 2 ? 'Adaptation' : 'Mastery'} Phase</p>
            </div>
            <div className="flex items-center w-full md:w-auto justify-center md:justify-start space-x-3 bg-secondary-container bg-opacity-10 px-4 py-2 rounded-full border border-secondary-container/20">
              <span className="material-symbols-outlined text-secondary" style={{ fontVariationSettings: "'FILL' 1" }}>local_fire_department</span>
              <span className="font-mono-data text-mono-data text-secondary">{completedDaysCount} Day Streak</span>
            </div>
          </div>

          {/* Main Grid */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-gutter">
            
            {/* Left Column: Tasks */}
            <div className="lg:col-span-8 space-y-6">
              {/* Today's Tasks Card */}
              <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
                <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
                  <h3 className="font-headline-md text-headline-md text-on-surface">Today's Protocol</h3>
                  <span className="bg-primary-container text-on-primary-container font-label-md text-label-md px-3 py-1 rounded-full">{completedExercisesCount}/{totalExercises} Completed</span>
                </div>
                
                <div className="space-y-4">
                  {exercises.map((ex, idx) => (
                    <div 
                      key={ex.id || ex._id || idx}
                      className={`flex items-center p-4 border rounded-lg transition-all ${ex.completed ? 'bg-surface-container-low border-outline-variant' : 'bg-surface-container-lowest border-outline-variant hover:border-outline group'}`}
                    >
                      <div className="relative flex items-center justify-center mr-4 flex-shrink-0">
                        <input 
                          type="checkbox" 
                          checked={ex.completed}
                          onChange={() => toggleChallengeExercise(activeChallenge.id, currentDay, ex.id || ex._id)}
                          className="w-6 h-6 border-outline text-primary rounded-sm focus:ring-primary focus:ring-opacity-50 cursor-pointer" 
                        />
                      </div>
                      <div className="flex-1 min-w-0 pr-4">
                        <h4 className={`font-headline-sm text-headline-sm text-on-surface break-words ${ex.completed ? 'line-through text-opacity-60' : ''}`}>{ex.title}</h4>
                        <p className="font-body-sm text-body-sm text-on-surface-variant break-words mt-1">
                          {ex.sets && ex.reps ? `${ex.sets} sets x ${ex.reps} reps` : ex.description || 'Focus on form'}
                        </p>
                      </div>
                      <span className={`material-symbols-outlined flex-shrink-0 ${ex.completed ? 'text-outline-variant' : 'text-secondary group-hover:scale-110 transition-transform'}`}>
                        fitness_center
                      </span>
                    </div>
                  ))}
                  {exercises.length === 0 && (
                     <p className="text-on-surface-variant text-center">No structured exercises found for today.</p>
                  )}
                </div>

                <div className="mt-8 pt-6 border-t border-outline-variant">
                  <button 
                    onClick={handleCompleteDay}
                    className="w-full bg-primary hover:bg-surface-tint text-on-primary font-headline-sm text-headline-sm py-4 rounded-lg transition-colors flex items-center justify-center space-x-2 disabled:opacity-50"
                    disabled={!allExercisesCompleted && totalExercises > 0}
                  >
                    <span className="material-symbols-outlined">{totalExercises === 0 ? 'skip_next' : 'check_circle'}</span>
                    <span>{totalExercises === 0 ? 'Skip Rest Day' : (currentDay === activeChallenge.generatedPlan.length ? 'Complete Challenge' : 'Complete Day')}</span>
                  </button>
                </div>
              </div>
            </div>

            {/* Right Column: Stats & Badges */}
            <div className="lg:col-span-4 space-y-6">
              
              {/* Daily Progress Ring Card */}
              <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm flex flex-col items-center justify-center">
                <h3 className="font-headline-sm text-headline-sm text-on-surface w-full text-left mb-4">Readiness Impact</h3>
                <div className="relative w-40 h-40 md:w-48 md:h-48 flex items-center justify-center">
                  {/* SVG Progress Ring */}
                  <svg className="w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                    <circle className="text-surface-container-high stroke-current" cx="50" cy="50" fill="transparent" r="40" strokeWidth="8"></circle>
                    <circle 
                      className="text-secondary stroke-current" 
                      cx="50" 
                      cy="50" 
                      fill="transparent" 
                      r="40" 
                      strokeDasharray="251.2" 
                      strokeDashoffset={251.2 - (251.2 * (totalExercises > 0 ? completedExercisesCount / totalExercises : 0))} 
                      strokeLinecap="round" 
                      strokeWidth="8"
                      style={{ transition: 'stroke-dashoffset 0.35s' }}
                    ></circle>
                  </svg>
                  <div className="absolute flex flex-col items-center justify-center">
                    <span className="font-display-md text-display-md text-on-surface">{totalExercises > 0 ? Math.round((completedExercisesCount / totalExercises) * 100) : 0}%</span>
                    <span className="font-label-md text-label-md text-on-surface-variant">Completed</span>
                  </div>
                </div>
                <p className="font-body-sm text-body-sm text-on-surface-variant mt-4 text-center">Completing today's protocol will boost your readiness score by an estimated +4 points.</p>
              </div>

              {/* Achievements Card */}
              <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
                <div className="flex justify-between items-center mb-4">
                  <h3 className="font-headline-sm text-headline-sm text-on-surface">Current Badges</h3>
                  <a className="font-label-md text-label-md text-primary hover:underline" href="#">View All</a>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-surface-container flex flex-col items-center justify-center p-4 rounded-lg border border-outline-variant text-center overflow-hidden">
                    <span className="material-symbols-outlined text-[32px] md:text-[36px] text-secondary mb-2 whitespace-nowrap" style={{ fontVariationSettings: "'FILL' 1" }}>workspace_premium</span>
                    <span className="font-label-md text-label-md text-on-surface truncate w-full">7 Day Warrior</span>
                  </div>
                  <div className="bg-surface-container flex flex-col items-center justify-center p-4 rounded-lg border border-outline-variant opacity-50 grayscale text-center overflow-hidden">
                    <span className="material-symbols-outlined text-[32px] md:text-[36px] text-outline mb-2 whitespace-nowrap">military_tech</span>
                    <span className="font-label-md text-label-md text-on-surface truncate w-full">21 Day Elite</span>
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>
      )}

      {/* Abandon Modal */}
      {showAbandonModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-on-background bg-opacity-50 backdrop-blur-sm">
          <div className="bg-surface-container-lowest rounded-xl border border-outline-variant shadow-xl p-8 max-w-sm w-full mx-4 text-center transform transition-all scale-100 opacity-100">
            <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-error-container mb-6">
              <span className="material-symbols-outlined text-error text-4xl">warning</span>
            </div>
            <h3 className="font-headline-md text-headline-md text-on-surface mb-2">Abandon Challenge?</h3>
            <p className="font-body-sm text-body-sm text-on-surface-variant mb-6">
              Are you sure you want to abandon this challenge? All progress will be logged as incomplete, and this action cannot be undone.
            </p>
            <div className="flex flex-col space-y-3">
              <button 
                onClick={handleAbandonChallenge}
                className="w-full bg-error text-on-error font-label-md text-label-md py-3 rounded-lg hover:bg-error-container hover:text-error transition-colors"
              >
                Yes, Abandon
              </button>
              <button 
                onClick={() => setShowAbandonModal(false)}
                className="w-full bg-transparent border border-outline-variant text-on-surface font-label-md text-label-md py-3 rounded-lg hover:bg-surface-container-low transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
}
