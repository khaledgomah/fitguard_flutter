import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useProfileStore } from '../store/profileStore';
import { useChallengeStore } from '../store/challengeStore';
import { useRecoveryStore } from '../store/recoveryStore';
import { useInjuryStore } from '../store/injuryStore';
import { useDashboardStore } from '../store/dashboardStore';

export default function Dashboard() {
  const { profile, fetchProfile } = useProfileStore();
  const { activeChallenge, fetchActiveChallenge } = useChallengeStore();
  const { activeProtocol, fetchActiveProtocol } = useRecoveryStore();
  const { injuries, fetchInjuries } = useInjuryStore();
  const { stats, fetchStats } = useDashboardStore();

  useEffect(() => {
    fetchProfile();
    fetchActiveChallenge();
    fetchActiveProtocol();
    fetchInjuries();
    fetchStats();
  } // eslint-disable-next-line react-hooks/exhaustive-deps
  , []);

  const activityScore = stats?.activityScore ?? null;
  const currentPhaseStr = activeProtocol ? `Protocol Phase ${activeProtocol.currentPhase}` : activeChallenge ? `Challenge Day ${activeChallenge.generatedPlan?.findIndex(d => !d.completed) + 1 || 1}` : 'Maintenance';
  console.log(activeChallenge)
  return (
    <div className="max-w-container-max mx-auto space-y-6">
      {/* Welcome Header */}
      <div className="flex justify-between items-end mb-8">
        <div>
          <h1 className="font-display-md text-display-md text-on-surface mb-2">Welcome back, {profile?.name?.split(' ')[0]}</h1>
          <p className="font-body-lg text-body-lg text-on-surface-variant">Here is your daily performance and recovery briefing.</p>
        </div>
        <div className="flex space-x-3 hidden sm:flex">
          <Link to="/injuries/create" className="px-4 py-2 bg-transparent border border-outline-variant text-on-surface font-label-md text-label-md rounded-lg hover:border-outline transition-colors flex items-center space-x-2">
            <span className="material-symbols-outlined text-sm">healing</span>
            <span>Log Injury</span>
          </Link>
          <Link to="/challenges/generate" className="px-4 py-2 bg-secondary text-on-secondary font-label-md text-label-md rounded-lg hover:bg-secondary-container hover:text-on-secondary-container transition-colors shadow-sm flex items-center space-x-2">
            <span className="material-symbols-outlined text-sm">auto_awesome</span>
            <span>Generate Challenge</span>
          </Link>
          <Link to="/recovery/generate" className="px-4 py-2 bg-primary-container text-on-primary-container font-label-md text-label-md rounded-lg hover:bg-primary hover:text-on-primary transition-colors shadow-sm flex items-center space-x-2">
            <span className="material-symbols-outlined text-sm">bolt</span>
            <span>Recovery Protocol</span>
          </Link>
        </div>
      </div>

      {/* Bento Grid */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-6">
        
        {/* Athlete Summary Card (4 columns) */}
        <div className="md:col-span-4 bg-surface-container-lowest border border-surface-variant hover:border-outline-variant transition-colors rounded-xl p-6 flex flex-col justify-between">
          <div>
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-headline-sm text-headline-sm text-on-surface">Athlete Status</h2>
              <span className="material-symbols-outlined text-on-surface-variant">more_horiz</span>
            </div>
            <div className="flex items-center space-x-4 mb-6">
              <div className="w-16 h-16 rounded-full bg-surface-container-high border border-outline-variant overflow-hidden flex-shrink-0">
                <img 
                  alt="Athlete" 
                  className="w-full h-full object-cover" 
                  src={profile?.avatarUrl || `https://ui-avatars.com/api/?name=${encodeURIComponent(profile?.name || 'Athlete')}&background=006c49&color=fff`}
                />
              </div>
              <div>
                <h3 className="font-headline-sm text-headline-sm text-on-surface">{profile?.name}</h3>
                <p className="font-body-sm text-body-sm text-on-surface-variant">{profile?.role}</p>
              </div>
            </div>
            
            <div className="space-y-4">
              <div className="flex justify-between items-center py-2 border-b border-surface-variant">
                <span className="font-body-sm text-body-sm text-on-surface-variant">Current Focus</span>
                <span className="font-label-md text-label-md text-on-surface bg-surface-container-high px-2 py-1 rounded">{currentPhaseStr}</span>
              </div>
              <div className="flex justify-between items-center py-2 border-b border-surface-variant">
                <span className="font-body-sm text-body-sm text-on-surface-variant">Systemic Load</span>
                <span className="font-mono-data text-mono-data text-on-surface">Tracking</span>
              </div>
            </div>
          </div>
          
          <div className="mt-6">
            <div className="flex justify-between items-end mb-2">
              <span className="font-headline-sm text-headline-sm text-on-surface">Activity Completion</span>
              <span className="font-display-md text-display-md text-primary-container leading-none">{activityScore !== null ? activityScore : '--'}<span className="text-headline-sm text-on-surface-variant ml-1">%</span></span>
            </div>
            <div className="w-full h-2 bg-surface-variant rounded-full overflow-hidden">
              <div className="h-full bg-primary-container rounded-full" style={{ width: `${activityScore !== null ? activityScore : 0}%` }}></div>
            </div>
            <p className="font-body-sm text-body-sm text-on-surface-variant mt-2">7-day task completion rate.</p>
          </div>
        </div>

        {/* Health Overview Chart (8 columns) */}
        <div className="md:col-span-8 bg-surface-container-lowest border border-surface-variant hover:border-outline-variant transition-colors rounded-xl p-6 relative overflow-hidden">
          <div className="flex justify-between items-center mb-6 relative z-10">
            <div>
              <h2 className="font-headline-sm text-headline-sm text-on-surface">Activity Trends</h2>
              <p className="font-body-sm text-body-sm text-on-surface-variant">Assigned vs. Completed Tasks (Last 7 Days)</p>
            </div>
            <div className="flex space-x-2">
              <span className="flex items-center text-body-sm font-body-sm text-on-surface-variant"><span className="w-2 h-2 rounded-full bg-secondary mr-2"></span>Assigned</span>
              <span className="flex items-center text-body-sm font-body-sm text-on-surface-variant"><span className="w-2 h-2 rounded-full bg-primary-container mr-2"></span>Completed</span>
            </div>
          </div>
          
          {/* Chart Bars/Lines Simulation */}
          <div className="h-[240px] w-full flex items-end justify-between space-x-2 relative z-10 pb-6 border-b border-surface-variant">
            <div className="w-full flex justify-between items-end h-full px-4">
              {stats?.activityHistory && stats.activityHistory.length > 0 ? (
                stats.activityHistory.map((data, index) => (
                  <div key={index} className="flex flex-col items-center space-y-2 relative group cursor-pointer">
                    <div className="absolute -top-10 bg-on-background text-surface px-2 py-1 rounded text-[10px] font-mono-data opacity-0 group-hover:opacity-100 transition-opacity z-20 whitespace-nowrap">
                      {data.completed} / {data.assigned} Completed
                    </div>
                    <div className="flex space-x-0.5 items-end">
                      <div 
                        className="w-3 bg-secondary/80 rounded-t-sm" 
                        style={{ height: `${data.assigned * 20}px` }}
                      ></div>
                      <div 
                        className="w-3 bg-primary-container/80 rounded-t-sm" 
                        style={{ height: `${data.completed * 20}px` }}
                      ></div>
                    </div>
                    <span className="font-mono-data text-[10px] text-on-surface-variant">{data.day}</span>
                  </div>
                ))
              ) : (
                <div className="w-full h-full flex flex-col items-center justify-center pt-8">
                  <span className="material-symbols-outlined text-surface-variant text-4xl mb-2">query_stats</span>
                  <p className="text-on-surface-variant font-body-sm">No activity history available.</p>
                </div>
              )}
            </div>
            
            {/* Background grid lines */}
            <div className="absolute inset-0 flex flex-col justify-between pointer-events-none pb-6">
              <div className="w-full border-t border-surface-variant border-dashed"></div>
              <div className="w-full border-t border-surface-variant border-dashed"></div>
              <div className="w-full border-t border-surface-variant border-dashed"></div>
              <div className="w-full border-t border-surface-variant border-dashed"></div>
            </div>
          </div>
        </div>

        {/* Active Challenge Card (4 columns) */}
        <div className="md:col-span-4 bg-surface-container-lowest border border-surface-variant hover:border-outline-variant transition-colors rounded-xl p-6 border-t-4 border-t-secondary flex flex-col">
          <div className="flex justify-between items-start mb-4">
            <div className="p-2 bg-secondary/10 rounded-lg text-secondary">
              <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>directions_run</span>
            </div>
            <span className="px-2 py-1 bg-secondary/10 text-secondary font-label-md text-label-md rounded">Active Initiative</span>
          </div>
          {activeChallenge?.status == "active" ? (
            <>
              <h3 className="font-headline-sm text-headline-sm text-on-surface mb-2 capitalize">{activeChallenge.sport} Protocol</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-6 capitalize">{activeChallenge.difficulty} difficulty AI plan.</p>
              <div className="space-y-3 flex-1">
                <div className="flex justify-between items-center">
                  <span className="font-body-sm text-body-sm text-on-surface">Duration</span>
                  <span className="font-mono-data text-mono-data text-secondary">{activeChallenge.generatedPlan?.length || 30} Days</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="font-body-sm text-body-sm text-on-surface">Status</span>
                  <span className="font-mono-data text-mono-data text-secondary">In Progress</span>
                </div>
              </div>
              <Link to="/challenges/active" className="block w-full mt-6 py-2 bg-surface-container hover:bg-surface-variant text-on-surface font-label-md text-label-md rounded-lg transition-colors text-center">
                View Challenge Details
              </Link>
            </>
          ) : (
            <div className="flex-1 flex flex-col items-center justify-center text-center py-4">
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">No active challenges.</p>
              <Link to="/challenges/generate" className="text-secondary font-label-md hover:underline">Start a Challenge</Link>
            </div>
          )}
        </div>

        {/* Active Recovery Protocol (4 columns) */}
        <div className="md:col-span-4 bg-surface-container-lowest border border-surface-variant hover:border-outline-variant transition-colors rounded-xl p-6 border-t-4 border-t-primary-container flex flex-col">
          <div className="flex justify-between items-start mb-4">
            <div className="p-2 bg-primary-container/10 rounded-lg text-primary-container">
              <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>spa</span>
            </div>
            <span className="px-2 py-1 bg-primary-container/10 text-primary-container font-label-md text-label-md rounded">In Progress</span>
          </div>
          {activeProtocol ? (
            <>
              <h3 className="font-headline-sm text-headline-sm text-on-surface mb-2 capitalize">{activeProtocol.injuryLogId?.muscleGroup} {activeProtocol.injuryLogId?.injuryType}</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">Phase {activeProtocol.currentPhase} of {activeProtocol.phases?.length}</p>
              
              <div className="space-y-4 flex-1">
                <div>
                  <div className="flex justify-between text-body-sm font-body-sm mb-1">
                    <span className="text-on-surface">Protocol Completion</span>
                    <span className="text-on-surface-variant font-mono-data">{Math.round((activeProtocol.phases?.filter(p => p.completed).length / activeProtocol.phases?.length) * 100)}%</span>
                  </div>
                  <div className="w-full h-1.5 bg-surface-variant rounded-full overflow-hidden">
                    <div className="h-full bg-primary-container rounded-full" style={{ width: `${(activeProtocol.phases?.filter(p => p.completed).length / activeProtocol.phases?.length) * 100}%` }}></div>
                  </div>
                </div>
              </div>
              <Link to="/recovery/active" className="block w-full mt-6 py-2 bg-surface-container hover:bg-surface-variant text-on-surface font-label-md text-label-md rounded-lg transition-colors text-center">
                View Protocol
              </Link>
            </>
          ) : (
            <div className="flex-1 flex flex-col items-center justify-center text-center py-4">
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">No active recovery protocols.</p>
              <Link to="/recovery/generate" className="text-primary-container font-label-md hover:underline">Start Recovery</Link>
            </div>
          )}
        </div>

        {/* Recent Injuries (4 columns) */}
        <div className="md:col-span-4 bg-surface-container-lowest border border-surface-variant hover:border-outline-variant transition-colors rounded-xl p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="font-headline-sm text-headline-sm text-on-surface">Clinical Alerts</h2>
            <Link to="/injuries" className="text-on-surface-variant hover:text-on-surface transition-colors">
              <span className="material-symbols-outlined text-sm">open_in_new</span>
            </Link>
          </div>
          <div className="space-y-4">
            {(injuries.length > 0 ? injuries.slice(0, 2).map(i => ({
              id: i.id,
              title: `${i.muscleGroup} ${i.injuryType}`,
              desc: i.description || i.notes || '',
              type: i.severity === 'High' || i.severity === 'severe' ? 'error' : 'info',
              status: i.severity
            })) : []).map((injury, idx) => (
              <div key={injury.id || idx} className={`p-3 rounded-lg flex items-start space-x-3 ${injury.type === 'error' ? 'bg-error-container/10 border border-error-container/30' : 'bg-surface-container'}`}>
                <span className={`material-symbols-outlined mt-0.5 ${injury.type === 'error' ? 'text-error' : 'text-on-surface-variant'}`}>
                  {injury.type === 'error' ? 'warning' : 'info'}
                </span>
                <div>
                  <h4 className={`font-label-md text-label-md mb-1 ${injury.type === 'error' ? 'text-error' : 'text-on-surface'}`}>{injury.title}</h4>
                  <p className="font-body-sm text-[11px] text-on-surface-variant">{injury.desc}</p>
                  {injury.type !== 'error' && injury.status && (
                    <span className="inline-block mt-2 font-mono-data text-[10px] bg-surface-variant text-on-surface-variant px-1.5 py-0.5 rounded">{injury.status}</span>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

      </div>
    </div>
  );
}
