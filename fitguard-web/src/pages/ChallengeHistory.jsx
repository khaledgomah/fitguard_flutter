import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useChallengeStore } from '../store/challengeStore';

export default function ChallengeHistory() {
  const { challenges, fetchChallenges, loading } = useChallengeStore();

  useEffect(() => {
    fetchChallenges();
  } // eslint-disable-next-line react-hooks/exhaustive-deps
  , []);

  const completed = challenges.filter(c => c.status === 'completed').length;
  const inProgress = challenges.filter(c => c.status === 'active').length;

  return (
    <div className="p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full flex-1">
      {/* Page Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
        <div>
          <h1 className="text-headline-lg font-headline-lg text-on-background mb-1">Challenge History</h1>
          <p className="text-body-md font-body-md text-on-surface-variant">Track your performance initiatives.</p>
        </div>
        <Link to="/challenges/generate" className="ai-gradient text-on-secondary py-2.5 px-6 rounded-lg text-label-md font-label-md shadow-sm hover:shadow-md transition-all active:scale-95 flex items-center gap-2 border-none" style={{ background: 'linear-gradient(135deg, #8a4cfc 0%, #712ae2 100%)' }}>
          <span className="material-symbols-outlined" style={{ fontSize: '18px' }}>auto_awesome</span>
          Generate New
        </Link>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div className="bg-surface-container-lowest/90 backdrop-blur-md border border-outline-variant rounded-xl p-6 relative overflow-hidden">
          <div className="absolute -right-4 -top-4 text-surface-container-high opacity-50">
            <span className="material-symbols-outlined" style={{ fontSize: '100px' }}>check_circle</span>
          </div>
          <div className="relative z-10">
            <div className="text-label-md font-label-md text-on-surface-variant mb-2">COMPLETED</div>
            <div className="text-display-md font-display-md text-on-background">{completed}</div>
            <div className="text-body-sm font-body-sm text-primary mt-1 flex items-center gap-1">
              <span className="material-symbols-outlined" style={{ fontSize: '14px' }}>trending_up</span>
              Latest metrics
            </div>
          </div>
        </div>

        <div className="bg-surface-container-lowest/90 backdrop-blur-md border border-outline-variant rounded-xl p-6 relative overflow-hidden">
          <div className="absolute -right-4 -top-4 text-surface-container-high opacity-50">
            <span className="material-symbols-outlined" style={{ fontSize: '100px' }}>directions_run</span>
          </div>
          <div className="relative z-10">
            <div className="text-label-md font-label-md text-on-surface-variant mb-2">IN PROGRESS</div>
            <div className="text-display-md font-display-md text-on-background">{inProgress}</div>
            <div className="text-body-sm font-body-sm text-on-surface-variant mt-1">Active regimens</div>
          </div>
        </div>

        <div className="bg-surface-container-lowest/90 backdrop-blur-md border border-outline-variant rounded-xl p-6 relative overflow-hidden">
          <div className="absolute -right-4 -top-4 text-surface-container-high opacity-50">
            <span className="material-symbols-outlined" style={{ fontSize: '100px' }}>local_fire_department</span>
          </div>
          <div className="relative z-10">
            <div className="text-label-md font-label-md text-on-surface-variant mb-2">TOTAL LOGGED</div>
            <div className="text-display-md font-display-md text-on-background">{challenges.length}</div>
            <div className="text-body-sm font-body-sm text-secondary mt-1 flex items-center gap-1">
              <span className="material-symbols-outlined" style={{ fontSize: '14px' }}>star</span>
              Personal Best
            </div>
          </div>
        </div>
      </div>

      {/* Filter Tabs */}
      <div className="flex gap-4 mb-6 border-b border-outline-variant pb-px overflow-x-auto">
        <button className="px-4 py-2 text-label-md font-label-md text-primary border-b-2 border-primary whitespace-nowrap">All Challenges</button>
      </div>

      {loading && <p className="text-center text-on-surface-variant mb-6">Loading challenges...</p>}

      {!loading && challenges.length === 0 && (
        <div className="text-center py-12 bg-surface-container-lowest rounded-xl border border-surface-variant">
          <span className="material-symbols-outlined text-4xl text-on-surface-variant mb-4">sports_score</span>
          <h3 className="font-headline-sm text-on-surface">No Challenges Found</h3>
          <p className="font-body-sm text-on-surface-variant mt-2 mb-6">Start tracking your recovery goals.</p>
          <Link to="/challenges/generate" className="bg-primary text-on-primary px-4 py-2 rounded-lg font-label-md">Generate Challenge</Link>
        </div>
      )}

      {/* Challenges Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        
        {challenges.map(challenge => (
          <Link key={challenge.id} to={`/challenges/${challenge.id}`} className="bg-surface-container-lowest/90 backdrop-blur-md border border-outline-variant rounded-xl overflow-hidden hover:shadow-md transition-shadow cursor-pointer group block">
            <div className="h-32 bg-surface-container relative">
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
              {challenge.status === 'active' && (
                <div className="absolute top-4 right-4 bg-surface/90 backdrop-blur-sm px-2 py-1 rounded text-label-md font-label-md text-primary flex items-center gap-1">
                  <span className="material-symbols-outlined" style={{ fontSize: '14px' }}>timelapse</span>
                  In Progress
                </div>
              )}
              {challenge.status === 'completed' && (
                <div className="absolute top-4 right-4 bg-surface/90 backdrop-blur-sm px-2 py-1 rounded text-label-md font-label-md text-primary-container flex items-center gap-1 border border-primary-container/30">
                  <span className="material-symbols-outlined" style={{ fontSize: '14px' }}>check_circle</span>
                  Completed
                </div>
              )}
            </div>
            <div className="p-5">
              <div className="flex justify-between items-start mb-2">
                <h3 className="text-headline-sm font-headline-sm text-on-background line-clamp-1 capitalize">{challenge.sport} Challenge</h3>
              </div>
              <p className="text-body-sm font-body-sm text-on-surface-variant mb-4 line-clamp-2 capitalize">{challenge.difficulty} Difficulty Level</p>
              <div className="mb-4">
                <div className="flex justify-between text-label-md font-label-md mb-1">
                  <span className="text-on-surface-variant">Status</span>
                  <span className="text-primary font-mono-data capitalize">{challenge.status || 'N/A'}</span>
                </div>
                <div className="flex justify-between text-label-md font-label-md mb-1">
                  <span className="text-on-surface-variant">Duration</span>
                  <span className="text-on-surface font-mono-data">{challenge.generatedPlan?.length || 0} Days</span>
                </div>
                <div className="flex justify-between text-label-md font-label-md mb-1">
                  <span className="text-on-surface-variant">Progress</span>
                  <span className="text-on-surface font-mono-data">{challenge.generatedPlan?.filter(d => d.completed).length || 0} / {challenge.generatedPlan?.length || 0} Days</span>
                </div>
                {challenge.completedAt && (
                  <div className="flex justify-between text-label-md font-label-md mb-1">
                    <span className="text-on-surface-variant">Completed At</span>
                    <span className="text-on-surface font-mono-data">{new Date(challenge.completedAt).toLocaleDateString()}</span>
                  </div>
                )}
              </div>
              <div className="flex items-center justify-between border-t border-surface-container pt-4">
                <div className="text-label-md font-label-md text-on-surface-variant flex items-center gap-1">
                  <span className="material-symbols-outlined" style={{ fontSize: '14px' }}>calendar_today</span>
                  Created At: {new Date(challenge.createdAt).toLocaleDateString()}
                </div>
                <button className="text-primary hover:text-primary-container transition-colors">
                  <span className="material-symbols-outlined">arrow_forward</span>
                </button>
              </div>
            </div>
          </Link>
        ))}

      </div>
    </div>
  );
}
