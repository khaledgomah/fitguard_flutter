import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useChallengeStore } from '../store/challengeStore';

export default function ChallengeDetails() {
  const { id } = useParams();
  const { fetchChallengeById } = useChallengeStore();
  const [challenge, setChallenge] = useState(null);

  useEffect(() => {
    fetchChallengeById(id).then(setChallenge);
  }, [id, fetchChallengeById]);

  if (!challenge) {
    return <div className="p-8 text-center text-on-surface-variant">Loading challenge details...</div>;
  }

  return (
    <div className="p-8 lg:p-12 w-full max-w-container-max mx-auto">
      {/* Header Section */}
      <div className="flex flex-col md:flex-row md:items-end justify-between mb-10 gap-6">
        <div>
          <div className="flex items-center gap-3 mb-2">
            <span className="bg-secondary/10 text-secondary font-label-md text-label-md px-3 py-1 rounded-full border border-secondary/20 uppercase tracking-widest">Plan Generated</span>
            <span className="text-on-surface-variant font-body-sm text-body-sm flex items-center gap-1">
              <span className="material-symbols-outlined text-[16px]">schedule</span> 30 Days
            </span>
          </div>
          <h2 className="font-display-md text-display-md text-on-surface capitalize">{challenge.sport} Resilience Protocol</h2>
          <p className="font-body-lg text-body-lg text-on-surface-variant mt-2 max-w-2xl">Your custom 30-day AI-generated plan focusing on controlled load management and tissue remodeling. Difficulty: <span className="capitalize">{challenge.difficulty}</span></p>
        </div>
        {challenge.status === 'active' && (
          <Link to="/challenges/active" className="bg-secondary text-on-secondary font-label-md text-label-md px-8 py-4 rounded-xl shadow-sm hover:shadow-md hover:bg-secondary/90 transition-all active:scale-95 flex items-center gap-2 whitespace-nowrap">
            <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>play_arrow</span>
            Continue Challenge
          </Link>
        )}
      </div>

      {/* Bento Grid Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 mb-12">
        {/* Primary Goal Card */}
        <div className="col-span-1 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col">
          <div className="flex items-center justify-between mb-6">
            <div className="h-10 w-10 rounded-lg bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-on-surface">target</span>
            </div>
            <span className="font-mono-data text-mono-data text-on-surface-variant">01</span>
          </div>
          <h3 className="font-headline-sm text-headline-sm text-on-surface mb-2">Primary Goal</h3>
          <p className="font-body-md text-body-md text-primary font-medium mb-3">Tendon Load Management</p>
          <p className="font-body-sm text-body-sm text-on-surface-variant mt-auto border-t border-surface-container pt-4">Gradual progressive overload designed to rebuild patellar capacity while avoiding acute flare-ups.</p>
        </div>

        {/* Weekly Structure Card */}
        <div className="col-span-1 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col relative overflow-hidden">
          <div className="absolute -right-6 -top-6 opacity-5">
            <span className="material-symbols-outlined text-[120px]">calendar_view_week</span>
          </div>
          <div className="flex items-center justify-between mb-6 relative z-10">
            <div className="h-10 w-10 rounded-lg bg-surface-container flex items-center justify-center">
              <span className="material-symbols-outlined text-on-surface">schema</span>
            </div>
            <span className="font-mono-data text-mono-data text-on-surface-variant">02</span>
          </div>
          <h3 className="font-headline-sm text-headline-sm text-on-surface mb-4 relative z-10">Weekly Progression</h3>
          <div className="space-y-3 relative z-10 mt-auto">
            <div className="flex justify-between items-center text-sm">
              <span className="font-label-md text-label-md text-on-surface-variant">W1: Isometric Control</span>
              <div className="w-16 h-1.5 bg-surface-container rounded-full overflow-hidden"><div className="h-full bg-primary w-1/4"></div></div>
            </div>
            <div className="flex justify-between items-center text-sm">
              <span className="font-label-md text-label-md text-on-surface-variant">W2: Heavy Slow Res.</span>
              <div className="w-16 h-1.5 bg-surface-container rounded-full overflow-hidden"><div className="h-full bg-primary w-2/4"></div></div>
            </div>
            <div className="flex justify-between items-center text-sm">
              <span className="font-label-md text-label-md text-on-surface-variant">W3: Energy Storage</span>
              <div className="w-16 h-1.5 bg-surface-container rounded-full overflow-hidden"><div className="h-full bg-tertiary-container w-3/4"></div></div>
            </div>
            <div className="flex justify-between items-center text-sm">
              <span className="font-label-md text-label-md text-on-surface-variant">W4: Sport Specific</span>
              <div className="w-16 h-1.5 bg-surface-container rounded-full overflow-hidden"><div className="h-full bg-tertiary w-full"></div></div>
            </div>
          </div>
        </div>

        {/* AI Recommendations Card */}
        <div className="col-span-1 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col border-t-4 border-t-secondary">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <span className="material-symbols-outlined text-secondary">memory</span>
              <span className="font-label-md text-label-md text-secondary uppercase tracking-widest">AI Insight</span>
            </div>
          </div>
          <h3 className="font-headline-sm text-headline-sm text-on-surface mb-4">Crucial Modulators</h3>
          <ul className="space-y-4 mt-auto">
            <li className="flex items-start gap-3">
              <span className="material-symbols-outlined text-[18px] text-primary mt-0.5">check_circle</span>
              <p className="font-body-sm text-body-sm text-on-surface-variant"><span className="font-semibold text-on-surface">Sleep Priority:</span> Target 8.5+ hours. Tendon synthesis peaks during deep REM cycles.</p>
            </li>
            <li className="flex items-start gap-3">
              <span className="material-symbols-outlined text-[18px] text-primary mt-0.5">check_circle</span>
              <p className="font-body-sm text-body-sm text-on-surface-variant"><span className="font-semibold text-on-surface">Collagen Intake:</span> Consume 15g Vitamin C-enriched collagen 60 mins pre-load.</p>
            </li>
          </ul>
        </div>
      </div>

      {/* 30 Day Schedule Section */}
      <div className="mb-8">
        <div className="flex items-center justify-between border-b border-outline-variant pb-4 mb-6">
          <h3 className="font-headline-md text-headline-md text-on-surface">Daily Breakdown</h3>
          <div className="hidden sm:flex items-center gap-4">
            <div className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-primary-container"></div><span className="font-label-md text-label-md text-on-surface-variant">Recovery</span></div>
            <div className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-surface-variant border border-outline-variant"></div><span className="font-label-md text-label-md text-on-surface-variant">Rest</span></div>
            <div className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-tertiary-container"></div><span className="font-label-md text-label-md text-on-surface-variant">Load</span></div>
          </div>
        </div>

        <div className="space-y-8">
          {[0, 1, 2, 3, 4].map(weekIndex => {
            const weekDays = challenge.generatedPlan.slice(weekIndex * 7, (weekIndex + 1) * 7);
            if (weekDays.length === 0) return null;
            return (
              <div key={weekIndex}>
                <h4 className="font-label-md text-label-md text-on-surface-variant uppercase tracking-widest mb-4">Week {weekIndex + 1}</h4>
                <div className="flex overflow-x-auto hide-scrollbar gap-4 pb-4">
                  {weekDays.map((dayObj) => (
                    <div key={dayObj.day} className={`min-w-[140px] flex-shrink-0 bg-surface-container-lowest border border-outline-variant rounded-xl p-4 hover:border-outline transition-colors cursor-pointer group ${dayObj.completed ? 'opacity-60 border-primary' : ''}`}>
                      <p className="font-mono-data text-mono-data text-on-surface-variant mb-2 flex justify-between">
                        <span>Day {dayObj.day.toString().padStart(2, '0')}</span>
                        {dayObj.completed && <span className="material-symbols-outlined text-primary text-[14px]">check_circle</span>}
                      </p>
                      <div className="w-8 h-8 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center mb-3 group-hover:scale-110 transition-transform">
                        <span className="material-symbols-outlined text-[18px]">fitness_center</span>
                      </div>
                      <p className="font-label-md text-label-md text-on-surface line-clamp-1">{dayObj.task}</p>
                      <p className="font-body-sm text-body-sm text-on-surface-variant mt-1 text-[11px] capitalize">{dayObj.muscleGroups?.join(', ')}</p>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
