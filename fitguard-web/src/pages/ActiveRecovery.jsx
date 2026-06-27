import { useState, useEffect } from 'react';
import { useRecoveryStore } from '../store/recoveryStore';
import { Link } from 'react-router-dom';

export default function ActiveRecovery() {
  const { activeProtocol, loading, error, fetchActiveProtocol, completePhase, toggleExercise } = useRecoveryStore();
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [showSuccessModal, setShowSuccessModal] = useState(false);

  useEffect(() => {
    fetchActiveProtocol();
  }, [fetchActiveProtocol]);

  // Case 5: API request failed
  if (error) {
    return <div className="p-8 text-center text-error">Failed to load protocol: {error}. Please refresh or try again later.</div>;
  }

  // Case: Still loading initial data
  if (loading && activeProtocol === null) {
    return <div className="p-8 text-center">Loading recovery protocol...</div>;
  }

  // Case 1, 2, 6: No active recovery exists
  if (!activeProtocol || Array.isArray(activeProtocol)) {
    return (
      <div className="p-8 text-center">
        <div className="mb-4 material-symbols-outlined text-6xl text-outline-variant">healing</div>
        <h2 className="text-xl font-headline-md mb-2">No Active Recovery Protocol</h2>
        <p className="text-on-surface-variant mb-4">You don't have any active recovery plans at the moment.</p>
        <Link to="/injuries" className="text-on-primary bg-primary px-6 py-2 rounded-lg inline-block">View Injuries</Link>
      </div>
    );
  }

  // Case 3, 4: Invalid phases array
  if (!activeProtocol.phases || !Array.isArray(activeProtocol.phases) || activeProtocol.phases.length === 0) {
    return (
      <div className="p-8 text-center">
        <h2 className="text-xl font-headline-md mb-2 text-error">Invalid Protocol Data</h2>
        <p className="text-on-surface-variant">This protocol is missing its phases. Please contact support or generate a new protocol.</p>
      </div>
    );
  }

  const handleCompletePhaseClick = () => {
    setShowConfirmModal(true);
  };

  const handleConfirmPhase = async () => {
    await completePhase(activeProtocol._id || activeProtocol.id, activeProtocol.currentPhase);
    setShowConfirmModal(false);
    setShowSuccessModal(true);
  };

  const currentPhaseIndex = activeProtocol.phases.findIndex(p => p.phaseNumber === activeProtocol.currentPhase);
  const currentPhaseData = currentPhaseIndex >= 0 ? activeProtocol.phases[currentPhaseIndex] : activeProtocol.phases[activeProtocol.phases.length - 1];
  const injury = activeProtocol.injuryLogId;

  return (
    <div className="p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full relative">
      {/* Header Section */}
      <div className="mb-8 flex flex-col md:flex-row justify-between items-start md:items-end gap-4">
        <div>
          <div className="flex items-center space-x-2 mb-2">
            <span className="px-2 py-1 rounded bg-error-container text-on-error-container font-label-md text-label-md">Active Protocol</span>
            <span className="text-on-surface-variant font-mono-data text-mono-data">ID: {activeProtocol.id?.substring(0, 8)}</span>
          </div>
          <h2 className="font-headline-lg text-headline-lg text-on-surface">{injury?.muscleGroup} {injury?.injuryType}</h2>
          <p className="font-body-lg text-body-lg text-on-surface-variant mt-1">{currentPhaseData?.name} • Moderate Load Phase</p>
        </div>
        <button 
          onClick={handleCompletePhaseClick}
          disabled={!currentPhaseData?.exercises?.every(ex => ex.completed)}
          className="bg-primary hover:bg-on-primary-container text-on-primary font-label-md text-label-md py-3 px-6 rounded-lg shadow-sm transition-colors flex items-center space-x-2 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span className="material-symbols-outlined">check_circle</span>
          <span>Complete Phase</span>
        </button>
      </div>

      {/* Layout Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-gutter">
        {/* Main Protocol Details & Tasks (12 columns) */}
        <div className="lg:col-span-12 space-y-gutter">
          {/* Timeline/Phases Card */}
          <div className="bg-surface-container-lowest rounded-xl border border-outline-variant p-6 shadow-sm">
            <h3 className="font-headline-sm text-headline-sm mb-6 flex items-center">
              <span className="material-symbols-outlined mr-2 text-primary">timeline</span>
              Recovery Phases
            </h3>
            <div className="relative">
              {/* Connecting Line */}
              <div className="absolute left-4 top-0 bottom-0 w-0.5 bg-surface-variant ml-[-1px]"></div>
              <div className="space-y-6">
                {activeProtocol.phases.map((phase) => {
                  const isCompleted = phase.completed;
                  const isCurrent = phase.phaseNumber === activeProtocol.currentPhase;
                  
                  if (isCompleted) {
                    return (
                      <div key={phase.phaseNumber} className="relative flex items-start pl-10 opacity-60">
                        <div className="absolute left-2.5 top-1.5 w-3 h-3 rounded-full bg-outline-variant outline outline-4 outline-surface-container-lowest"></div>
                        <div>
                          <h4 className="font-label-md text-label-md text-outline">Phase {phase.phaseNumber}: {phase.name}</h4>
                          <p className="font-body-sm text-body-sm text-outline-variant mt-1">{phase.durationDays} Days</p>
                        </div>
                      </div>
                    );
                  } else if (isCurrent) {
                    return (
                      <div key={phase.phaseNumber} className="relative flex items-start pl-10">
                        <div className="absolute left-2 top-1 w-4 h-4 rounded-full bg-primary outline outline-4 outline-primary-container animate-pulse"></div>
                        <div className="bg-surface-container p-4 rounded-lg border border-outline-variant w-full">
                          <div className="flex justify-between items-center mb-2">
                            <h4 className="font-label-md text-label-md text-primary">Phase {phase.phaseNumber}: {phase.name} (Current)</h4>
                            <span className="px-2 py-0.5 rounded text-xs font-mono-data bg-surface-lowest text-on-surface-variant border border-outline-variant">{phase.durationDays} Days</span>
                          </div>
                          <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">{phase.exercises.map(e => e.title || e.name || (typeof e === 'string' ? e : 'Unnamed Exercise')).join(', ')}</p>
                          {/* Progress Bar */}
                          <div className="w-full bg-surface-variant rounded-full h-2.5 mb-1">
                            <div className="bg-primary h-2.5 rounded-full" style={{ width: '45%' }}></div>
                          </div>
                          <p className="text-right text-xs font-mono-data text-on-surface-variant">Active</p>
                        </div>
                      </div>
                    );
                  } else {
                    return (
                      <div key={phase.phaseNumber} className="relative flex items-start pl-10">
                        <div className="absolute left-2.5 top-1.5 w-3 h-3 rounded-full bg-surface-variant outline outline-4 outline-surface-container-lowest"></div>
                        <div>
                          <h4 className="font-label-md text-label-md text-on-surface-variant">Phase {phase.phaseNumber}: {phase.name}</h4>
                          <p className="font-body-sm text-body-sm text-outline mt-1">{phase.durationDays} Days</p>
                        </div>
                      </div>
                    );
                  }
                })}
              </div>
            </div>
          </div>

          {/* Daily Tasks Card */}
          <div className="bg-surface-container-lowest rounded-xl border border-outline-variant p-6 shadow-sm">
            <div className="flex justify-between items-center mb-6">
              <h3 className="font-headline-sm text-headline-sm flex items-center">
                <span className="material-symbols-outlined mr-2 text-primary">task_alt</span>
                Today's Protocol
              </h3>
              <span className="font-mono-data text-mono-data text-on-surface-variant">{new Date().toLocaleDateString()}</span>
            </div>
            <div className="space-y-3">
              {currentPhaseData?.exercises.map((exercise, idx) => (
                <label key={exercise._id || exercise.id || idx} className="flex items-center p-4 rounded-lg border border-outline-variant hover:bg-surface-container-low cursor-pointer transition-colors group">
                  <input 
                    type="checkbox" 
                    checked={exercise.completed || false}
                    onChange={() => toggleExercise(activeProtocol.id || activeProtocol._id, activeProtocol.currentPhase, exercise.id || exercise._id)}
                    className="form-checkbox h-5 w-5 text-primary rounded border-outline-variant focus:ring-primary focus:ring-offset-0 bg-surface mr-4" 
                  />
                  <div className="flex-grow">
                    <span className={`font-body-md text-body-md text-on-surface group-hover:text-primary transition-colors ${exercise.completed ? 'line-through opacity-60' : ''}`}>
                      {exercise.title || exercise.name || exercise}
                    </span>
                    {exercise.sets && <span className="block font-body-sm text-body-sm text-on-surface-variant">{exercise.sets} sets x {exercise.reps}</span>}
                  </div>
                  <span className="material-symbols-outlined text-outline-variant group-hover:text-primary">fitness_center</span>
                </label>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Confirm Modal */}
      {showConfirmModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-on-background bg-opacity-50 backdrop-blur-sm">
          <div className="bg-surface-container-lowest rounded-xl border border-outline-variant shadow-xl p-8 max-w-sm w-full mx-4 text-center transform transition-all scale-100 opacity-100">
            <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-secondary-container mb-6">
              <span className="material-symbols-outlined text-on-secondary-container text-4xl">help</span>
            </div>
            <h3 className="font-headline-md text-headline-md text-on-surface mb-2">Complete Phase?</h3>
            <p className="font-body-sm text-body-sm text-on-surface-variant mb-6">
              Are you sure you want to mark this phase as complete? You will not be able to undo this action.
            </p>
            <div className="flex flex-col space-y-3">
              <button 
                onClick={handleConfirmPhase}
                className="w-full bg-primary text-on-primary font-label-md text-label-md py-3 rounded-lg hover:bg-on-primary-container transition-colors"
              >
                Confirm Completion
              </button>
              <button 
                onClick={() => setShowConfirmModal(false)}
                className="w-full bg-transparent border border-outline-variant text-on-surface font-label-md text-label-md py-3 rounded-lg hover:bg-surface-container-low transition-colors"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Success Modal */}
      {showSuccessModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-on-background bg-opacity-50 backdrop-blur-sm">
          <div className="bg-surface-container-lowest rounded-xl border border-outline-variant shadow-xl p-8 max-w-sm w-full mx-4 text-center transform transition-all scale-100 opacity-100">
            <div className="mx-auto flex items-center justify-center h-16 w-16 rounded-full bg-primary-container mb-6">
              <span className="material-symbols-outlined text-on-primary-container text-4xl">verified</span>
            </div>
            <h3 className="font-headline-md text-headline-md text-on-surface mb-2">Phase Completed</h3>
            <p className="font-body-sm text-body-sm text-on-surface-variant mb-6">
              Excellent work. Phase {activeProtocol.currentPhase} data has been logged.
            </p>
            <div className="flex flex-col space-y-3">
              <button 
                onClick={() => {
                  setShowSuccessModal(false);
                  fetchActiveProtocol();
                }}
                className="w-full bg-primary text-on-primary font-label-md text-label-md py-3 rounded-lg hover:bg-on-primary-container transition-colors"
              >
                Continue
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
