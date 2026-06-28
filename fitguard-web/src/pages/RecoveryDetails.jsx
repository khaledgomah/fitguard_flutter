import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useRecoveryStore } from '../store/recoveryStore';

export default function RecoveryDetails() {
  const { id } = useParams();
  const { fetchProtocolById } = useRecoveryStore();
  const [protocol, setProtocol] = useState(null);

  useEffect(() => {
    fetchProtocolById(id).then(setProtocol);
  }, [id, fetchProtocolById]);

  if (!protocol) {
    return <div className="p-8 text-center text-on-surface-variant">Loading recovery protocol...</div>;
  }

  const currentPhaseIndex = protocol.phases.findIndex(p => !p.completed);
  const displayPhase = currentPhaseIndex === -1 ? protocol.phases.length : currentPhaseIndex + 1;
  const currentPhaseData = protocol.phases[displayPhase - 1];
  
  return (
    <div className="p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full pb-24">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-end mb-8 gap-4">
        <div>
          <div className="inline-flex items-center space-x-2 bg-secondary-fixed text-on-secondary-fixed font-label-md text-label-md px-3 py-1 rounded-full mb-3">
            <span className="material-symbols-outlined text-[14px]">auto_awesome</span>
            <span>AI-Generated Protocol</span>
          </div>
          <h2 className="font-display-md text-display-md text-on-surface mb-2 capitalize">{protocol.injuryLogId?.muscleGroup} {protocol.injuryLogId?.injuryType} Recovery</h2>
          <p className="font-body-lg text-body-lg text-on-surface-variant max-w-2xl">
            A clinical, data-driven recovery timeline optimized based on your recent biomechanical stress test and historical injury data.
          </p>
        </div>
        <div className="flex space-x-4">
          <button className="px-6 py-2 border border-outline-variant text-on-surface font-label-md text-label-md rounded-lg hover:bg-surface-container transition-colors">
            Edit Parameters
          </button>
          {protocol.status === 'active' && (
            <Link to="/recovery/active" className="px-6 py-2 bg-primary-container text-on-primary font-label-md text-label-md rounded-lg hover:opacity-90 transition-opacity flex items-center shadow-sm">
              Continue Protocol
              <span className="material-symbols-outlined ml-2 text-[18px]">check_circle</span>
            </Link>
          )}
        </div>
      </div>

      {/* Bento Grid Layout */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        {/* Timeline Overview (Spans 12 columns) */}
        <div className="md:col-span-12 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 relative overflow-hidden">
          <div className="absolute top-0 right-0 w-64 h-full bg-gradient-to-l from-surface-container-low to-transparent pointer-events-none"></div>
          <div className="flex justify-between items-center mb-6">
            <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center">
              <span className="material-symbols-outlined mr-2 text-primary">timeline</span>
              12-Week Trajectory
            </h3>
            <span className="font-mono-data text-mono-data text-on-surface-variant hidden md:block">Estimated Full Clearance: {protocol.endDate ? new Date(protocol.endDate).toLocaleDateString() : 'Pending'}</span>
          </div>
          <div className="relative w-full h-32 flex items-center justify-between px-4 overflow-x-auto pb-4 md:pb-0">
            {/* Connecting Line */}
            <div className="absolute left-8 right-8 top-1/2 h-1 bg-surface-variant -z-10 rounded-full min-w-[600px] md:min-w-0"></div>
            <div className="absolute left-8 w-1/4 top-1/2 h-1 bg-primary-container -z-10 rounded-full"></div> {/* Progress indicator */}
            
            {/* Phase Nodes */}
            <div className="flex w-[600px] md:w-full justify-between items-center px-4">
              {protocol.phases.map(phase => {
                const isActive = phase.phaseNumber === displayPhase;
                const isCompleted = phase.completed;
                
                return (
                  <div key={phase.phaseNumber} className={`flex flex-col items-center group cursor-pointer shrink-0 w-24 ${!isActive && !isCompleted ? 'opacity-70' : ''}`}>
                    <div className={`w-12 h-12 rounded-full flex items-center justify-center relative z-10 ${isActive ? 'bg-surface-container-lowest border-2 border-primary shadow-sm' : 'bg-surface-container border border-outline-variant'}`}>
                      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${isActive ? 'bg-primary-container text-on-primary' : isCompleted ? 'bg-secondary text-white' : 'text-outline'}`}>
                        {isCompleted ? <span className="material-symbols-outlined text-[16px]">check</span> : <span className="font-mono-data text-mono-data">{phase.phaseNumber}</span>}
                      </div>
                    </div>
                    <div className="mt-3 text-center">
                      <p className={`font-label-md text-label-md ${isActive || isCompleted ? 'text-primary' : 'text-on-surface'}`}>Phase {phase.phaseNumber}</p>
                      <p className="font-body-sm text-body-sm text-on-surface-variant truncate w-24" title={phase.name}>{phase.name}</p>
                      {isActive && <p className="font-mono-data text-[10px] text-primary mt-1 opacity-100">ACTIVE</p>}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Current Phase Clinical Instructions (Spans 8 columns) */}
        <div className="md:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col">
          <div className="flex justify-between items-center mb-6 pb-4 border-b border-surface-container-high">
            <div>
              <h3 className="font-headline-sm text-headline-sm text-on-surface">Phase {currentPhaseData.phaseNumber}: {currentPhaseData.name}</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant">Duration: {currentPhaseData.durationDays} Days</p>
            </div>
            {protocol.status === 'active' && (
              <div className="bg-primary-container text-on-primary-container px-3 py-1 rounded font-mono-data text-mono-data flex items-center">
                <span className="material-symbols-outlined text-[14px] mr-1">timelapse</span>
                In Progress
              </div>
            )}
          </div>
          
          <div className="space-y-6 flex-1">
            {currentPhaseData.exercises?.length > 0 ? currentPhaseData.exercises.map((ex, index) => (
              <div key={index} className="flex items-start space-x-4">
                <div className="w-8 h-8 rounded bg-surface-container-low border border-outline-variant flex items-center justify-center shrink-0 mt-1">
                  <span className="font-mono-data text-mono-data text-on-surface">{(index + 1).toString().padStart(2, '0')}</span>
                </div>
                <div>
                  <h4 className="font-label-md text-label-md text-on-surface mb-1">{ex.name}</h4>
                  <p className="font-body-md text-body-md text-on-surface-variant">
                    {ex.sets} sets of {ex.reps} reps
                  </p>
                  <p className="font-body-sm text-body-sm text-on-surface-variant opacity-80 mt-1">
                    Frequency: {ex.frequency}
                  </p>
                </div>
              </div>
            )) : (
              <p className="text-on-surface-variant">No specific exercises listed for this phase.</p>
            )}
          </div>
        </div>

        {/* Biometric Target Card (Spans 4 columns) */}
        <div className="md:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col relative overflow-hidden group">
          {/* Subtle background graphic */}
          <div className="absolute -right-10 -bottom-10 w-40 h-40 bg-surface-container-low rounded-full opacity-50 pointer-events-none group-hover:scale-110 transition-transform duration-500"></div>
          
          <h3 className="font-headline-sm text-headline-sm text-on-surface mb-6 flex items-center z-10">
            <span className="material-symbols-outlined mr-2 text-on-surface-variant">target</span>
            Phase Targets
          </h3>
          
          <div className="space-y-5 z-10">
            {/* Target 1 */}
            <div>
              <div className="flex justify-between font-label-md text-label-md mb-2">
                <span className="text-on-surface">Primary Goal</span>
              </div>
              <p className="font-body-md text-on-surface-variant">{protocol.goal || 'Return to play'}</p>
            </div>
            
            {/* Target 2 */}
            <div className="pt-4 border-t border-surface-container">
              <div className="flex justify-between font-label-md text-label-md mb-2">
                <span className="text-on-surface">Biometric Target</span>
              </div>
              <p className="font-body-md text-on-surface-variant">{protocol.target || 'Restore full mobility'}</p>
            </div>
          </div>
          
          <div className="mt-auto pt-6 z-10">
            <div className="bg-primary-container/10 p-3 rounded-lg border border-primary-container/20">
              <p className="font-label-md text-label-md text-on-primary-container mb-1">AI Insight</p>
              <p className="font-body-sm text-body-sm text-on-surface-variant leading-tight">Focus on quad sets to overcome lag before progressing WBAT.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
