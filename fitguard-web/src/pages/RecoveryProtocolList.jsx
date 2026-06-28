import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useRecoveryStore } from '../store/recoveryStore';

export default function RecoveryProtocolList() {
  const { protocols, activeProtocol, fetchProtocols, fetchActiveProtocol, toggleExercise, loading } = useRecoveryStore();

  useEffect(() => {
    fetchProtocols();
    fetchActiveProtocol();
  } // eslint-disable-next-line react-hooks/exhaustive-deps
  , []);

  const hasActiveProtocol = !!activeProtocol;
  const injury = activeProtocol?.injuryLogId;
  const currentPhaseData = activeProtocol?.phases?.find(p => p.phaseNumber === activeProtocol.currentPhase);

  return (
    <div className="p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full">
      
      {loading && <p className="text-on-surface-variant mb-6 text-center">Loading recovery protocols...</p>}

      {!loading && hasActiveProtocol ? (
        <>
          <div className="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
            <div>
              <h2 className="font-display-md text-display-md text-on-background">Recovery Protocol</h2>
              <p className="font-body-lg text-body-lg text-on-surface-variant mt-1">Active Rehabilitation Phase</p>
            </div>
            <div className="flex space-x-3">
              <Link to="/recovery/generate" className="px-4 py-2 bg-primary text-on-primary rounded-lg font-label-md text-label-md hover:bg-on-primary-fixed-variant transition-colors flex items-center space-x-2">
                <span className="material-symbols-outlined text-[18px]">edit_document</span>
                <span>Adjust Protocol</span>
              </Link>
            </div>
          </div>

          {/* Bento Grid Layout */}
          <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
            {/* Active Protocol Overview (Spans 8 columns) */}
            {/* Active Protocol Overview (Spans 8 columns) */}
<Link 
  to="/recovery/active" 
  className="md:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 relative overflow-hidden flex flex-col justify-between cursor-pointer transition-all hover:border-primary hover:shadow-md hover:-translate-y-0.5"
>
  {/* Decorative ambient gradient */}
  <div className="absolute -right-20 -top-20 w-64 h-64 bg-primary-container opacity-20 blur-3xl rounded-full pointer-events-none"></div>
  <div>
    <div className="flex justify-between items-start mb-6">
      <div>
        <span className="px-3 py-1 bg-surface-container-highest text-on-surface rounded-full font-label-md text-label-md mb-3 inline-block">Active Protocol</span>
        <h3 className="font-headline-lg text-headline-lg text-on-background capitalize">{injury?.muscleGroup} {injury?.injuryType}</h3>
        <p className="font-body-md text-body-md text-on-surface-variant mt-2 max-w-lg">{currentPhaseData?.name} - {currentPhaseData?.durationDays} Days</p>
      </div>
      <div className="flex items-center space-x-2 bg-inverse-on-surface px-4 py-2 rounded-lg border border-outline-variant">
        <span className="material-symbols-outlined text-primary" style={{ fontVariationSettings: "'FILL' 0" }}>timeline</span>
        <div>
          <p className="font-label-md text-label-md text-on-surface-variant">Current Phase</p>
          <p className="font-headline-sm text-headline-sm text-on-background">Phase {activeProtocol.currentPhase} / {activeProtocol.phases?.length}</p>
        </div>
      </div>
    </div>
  </div>
  {/* Progress Timeline */}
  <div className="mt-8">
    <div className="flex justify-between font-label-md text-label-md text-on-surface-variant mb-2">
      <span>Phase Progress</span>
      <span className="text-primary font-bold">In Progress</span>
    </div>
    <div className="w-full h-2 bg-surface-variant rounded-full overflow-hidden">
      <div className="h-full bg-primary w-1/3 rounded-full relative">
        <div className="absolute right-0 top-0 bottom-0 w-8 bg-gradient-to-r from-transparent to-white opacity-30 animate-pulse"></div>
      </div>
    </div>
  </div>
</Link>

            {/* Daily Status/Readiness (Spans 4 columns) */}
            <div className="md:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col">
              <div className="flex justify-between items-center mb-6">
                <h3 className="font-headline-sm text-headline-sm text-on-background">Daily Readiness</h3>
                <button className="text-on-surface-variant hover:text-primary transition-colors">
                  <span className="material-symbols-outlined">more_horiz</span>
                </button>
              </div>
              <div className="flex-grow flex flex-col items-center justify-center">
                {/* Readiness Score Circle */}
                <div className="relative w-32 h-32 flex items-center justify-center mb-4">
                  <svg className="absolute inset-0 w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                    <circle className="text-surface-variant" cx="50" cy="50" fill="none" r="45" stroke="currentColor" strokeWidth="8"></circle>
                    <circle className="text-primary-container" cx="50" cy="50" fill="none" r="45" stroke="currentColor" strokeDasharray="282.7" strokeDashoffset="56.5" strokeLinecap="round" strokeWidth="8"></circle>
                  </svg>
                  <div className="text-center">
                    <span className="font-display-md text-display-md text-on-background block leading-none">82</span>
                    <span className="font-label-md text-label-md text-on-surface-variant">Optimal</span>
                  </div>
                </div>
                <div className="w-full space-y-3 mt-4">
                  <div className="flex justify-between items-center p-3 bg-surface rounded-lg border border-surface-variant">
                    <div className="flex items-center space-x-3">
                      <span className="material-symbols-outlined text-primary-container">vital_signs</span>
                      <span className="font-mono-data text-mono-data text-on-surface">Inflammation</span>
                    </div>
                    <span className="px-2 py-1 bg-emerald-50 text-emerald-500 rounded font-label-md text-label-md">Low</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Daily Mobility Tasks (Spans 12 columns) */}
            <div className="md:col-span-12 bg-surface-container-lowest border border-outline-variant rounded-xl p-6">
              <div className="flex justify-between items-center mb-6">
                <h3 className="font-headline-sm text-headline-sm text-on-background">Today's Protocol Tasks</h3>
                <span className="font-label-md text-label-md text-on-surface-variant">{currentPhaseData?.exercises?.length || 0} Exercises</span>
              </div>
              <div className="space-y-3">
                {currentPhaseData?.exercises?.map((exercise, idx) => (
                  <label key={exercise.id || exercise._id || idx} className="flex items-start space-x-4 p-4 rounded-lg border cursor-pointer transition-all border-primary-container bg-surface-container-lowest shadow-sm hover:shadow-md">
                    <input 
                      type="checkbox" 
                      checked={exercise.completed || false}
                      onChange={() => toggleExercise(activeProtocol.id || activeProtocol._id, activeProtocol.currentPhase, exercise.id || exercise._id)}
                      className="mt-1 w-5 h-5 rounded border-outline-variant text-primary focus:ring-primary focus:ring-offset-surface" 
                    />
                    <div className="flex-grow">
                      <p className={`font-body-md text-body-md font-medium text-on-background ${exercise.completed ? 'line-through opacity-60' : ''}`}>
                        {exercise.title || exercise.name || (typeof exercise === 'string' ? exercise : 'Untitled Exercise')}
                      </p>
                      {exercise.sets && <p className="text-sm text-on-surface-variant">{exercise.sets} sets x {exercise.reps}</p>}
                      {exercise.duration && <p className="text-sm text-on-surface-variant">{exercise.duration} mins/secs</p>}
                    </div>
                    <button className="text-on-surface-variant hover:text-primary" title="View Technique">
                      <span className="material-symbols-outlined">play_circle</span>
                    </button>
                  </label>
                ))}
              </div>
            </div>

          </div>
        </>
      ) : !loading ? (
        <div className="mt-8 w-full bg-surface-container border border-outline-variant border-dashed rounded-2xl p-12 flex flex-col items-center justify-center text-center">
          <div className="w-16 h-16 bg-surface-variant rounded-full flex items-center justify-center mb-4">
            <span className="material-symbols-outlined text-outline text-3xl">health_and_safety</span>
          </div>
          <h3 className="font-headline-md text-headline-md text-on-background mb-2">No Active Recovery Protocol</h3>
          <p className="font-body-md text-body-md text-on-surface-variant max-w-md mb-6">You currently don't have any active rehabilitation programs assigned. Connect with your medical professional to initiate a new protocol.</p>
          <Link to="/recovery/generate" className="px-6 py-3 bg-secondary-container text-on-secondary-fixed rounded-xl font-label-md text-label-md hover:opacity-90 transition-opacity">
            Request Assessment
          </Link>
        </div>
      ) : null}

      {/* Protocol History Section */}
      <div className="mt-12">
        <h3 className="font-headline-md text-headline-md text-on-surface mb-6">Protocol History</h3>
        
        {protocols.length === 0 ? (
          <p className="text-on-surface-variant text-center bg-surface-container-lowest p-8 rounded-xl border border-outline-variant">No protocols recorded yet.</p>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {protocols.map(protocol => (
              <div key={protocol.id || protocol._id} className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm hover:shadow-md transition-all">
                <div className="flex justify-between items-start mb-4">
                  <h4 className="font-headline-sm text-headline-sm text-on-surface capitalize">{protocol.injuryLogId?.muscleGroup || 'Recovery'} Protocol</h4>
                  <span className={`px-2 py-1 rounded text-label-md font-label-md ${protocol.status === 'active' ? 'bg-secondary-container text-secondary' : 'bg-surface-variant text-on-surface-variant'}`}>
                    {protocol.status}
                  </span>
                </div>
                
                <div className="space-y-3 mb-6">
                  <div className="flex justify-between font-body-sm text-body-sm">
                    <span className="text-on-surface-variant">Goal</span>
                    <span className="text-on-surface font-medium capitalize text-right ml-4 line-clamp-1">{protocol.goal || 'General Rehabilitation'}</span>
                  </div>
                  <div className="flex justify-between font-body-sm text-body-sm">
                    <span className="text-on-surface-variant">Target</span>
                    <span className="text-on-surface font-medium capitalize">{protocol.target || 'Full Recovery'}</span>
                  </div>
                  <div className="flex justify-between font-body-sm text-body-sm">
                    <span className="text-on-surface-variant">Current Phase</span>
                    <span className="text-on-surface font-medium">{protocol.currentPhase} / {protocol.phases?.length || 0}</span>
                  </div>
                </div>

                <div className="pt-4 border-t border-outline-variant space-y-2">
                  {protocol.endDate && (
                    <div className="flex justify-between font-label-md text-label-md text-on-surface-variant">
                      <span>Target End Date</span>
                      <span>{new Date(protocol.endDate).toLocaleDateString()}</span>
                    </div>
                  )}
                  {protocol.completedAt && (
                    <div className="flex justify-between font-label-md text-label-md text-on-surface-variant">
                      <span>Completed At</span>
                      <span className="text-primary">{new Date(protocol.completedAt).toLocaleDateString()}</span>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
