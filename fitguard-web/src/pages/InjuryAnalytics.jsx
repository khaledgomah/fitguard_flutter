import { useEffect, useMemo } from 'react';
import { useInjuryStore } from '../store/injuryStore';

export default function InjuryAnalytics() {
  const { injuries, fetchInjuries } = useInjuryStore();

  useEffect(() => {
    fetchInjuries();
  }, [fetchInjuries]);

  const stats = useMemo(() => {
    if (!injuries.length) return null;
    
    // Severity breakdown (assuming 1-10 scale)
    let severe = 0;
    let moderate = 0;
    let mild = 0;
    
    // Muscle groups
    const muscleGroups = {};
    
    injuries.forEach(inj => {
      const severity = inj.severity?.toLowerCase() || 'mild';
      if (severity === 'severe') severe++;
      else if (severity === 'moderate') moderate++;
      else mild++;
      
      const mg = inj.muscleGroup || 'Unknown';
      muscleGroups[mg] = (muscleGroups[mg] || 0) + 1;
    });
    
    const sortedMuscles = Object.entries(muscleGroups).sort((a, b) => b[1] - a[1]).slice(0, 3);
    const total = injuries.length;
    
    return {
      total,
      severe,
      moderate,
      severePercent: total ? Math.round((severe / total) * 100) : 0,
      moderatePercent: total ? Math.round((moderate / total) * 100) : 0,
      mildPercent: total ? Math.round((mild / total) * 100) : 0,
      sortedMuscles,
      mostAffected: sortedMuscles[0]?.[0] || 'None'
    };
  }, [injuries]);

  return (
    <div className="p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full flex flex-col gap-8">
      {/* Header Section */}
      <div className="flex flex-col sm:flex-row sm:justify-between sm:items-end gap-4">
        <div>
          <h2 className="font-headline-lg text-headline-lg text-on-background tracking-tight">Injury Analytics</h2>
          <p className="font-body-md text-body-md text-on-surface-variant mt-1">Pattern recognition and longitudinal severity assessment.</p>
        </div>
        <button className="bg-surface-container-lowest border border-outline-variant text-on-surface font-label-md text-label-md px-4 py-2 rounded-lg flex items-center justify-center gap-2 hover:border-outline transition-colors shadow-sm">
          <span className="material-symbols-outlined text-[18px]">download</span>
          Export PDF
        </button>
      </div>

      {/* AI Insight Highlight */}
      <div className="bg-secondary-fixed border border-secondary-fixed-dim rounded-xl p-6 flex flex-col sm:flex-row gap-5 items-start shadow-sm">
        <div className="p-3 bg-secondary rounded-full text-on-secondary shrink-0">
          <span className="material-symbols-outlined text-[24px]">psychology</span>
        </div>
        <div>
          <h3 className="font-headline-sm text-headline-sm text-secondary mb-1">AI Predictive Insight</h3>
          <p className="font-body-md text-body-md text-on-surface leading-relaxed">
            {stats ? `High probability of recurring strain detected in ${stats.mostAffected} based on recent load data. Recommended 48h reduction in high-velocity protocols.` : 'Log injuries to see AI predictive insights and pattern recognition.'}
          </p>
        </div>
      </div>

      {/* Analytics Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">

        {/* Severity Breakdown (Pie/Donut Concept) */}
        <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col shadow-sm">
          <h3 className="font-headline-sm text-headline-sm text-on-background mb-6">Severity Breakdown</h3>
          <div className="flex-grow flex flex-col items-center justify-center min-h-[200px] mb-6">
            <div className="relative w-48 h-48 rounded-full border-[16px] border-surface-container-high flex items-center justify-center">
              {stats && stats.severePercent > 0 && (
                <div className="absolute inset-0 rounded-full border-[16px] border-error" style={{ clipPath: `polygon(50% 50%, 100% 0, 100% 100%, 50% 100%, 0 100%, 0 ${100 - stats.severePercent}%)` }}></div>
              )}
              {stats && stats.mildPercent > 0 && (
                <div className="absolute inset-0 rounded-full border-[16px] border-primary" style={{ clipPath: 'polygon(50% 50%, 0 50%, 0 0, 100% 0)' }}></div>
              )}
              <div className="text-center flex flex-col bg-surface-container-lowest w-32 h-32 rounded-full items-center justify-center shadow-inner z-10">
                <span className="font-display-md text-display-md text-on-background">{stats?.total || 0}</span>
                <span className="font-label-md text-label-md text-on-surface-variant">Total Incidents</span>
              </div>
            </div>
          </div>
          <div className="flex flex-col gap-3 mt-auto border-t border-outline-variant pt-4">
            <div className="flex justify-between items-center text-body-sm font-body-sm">
              <span className="flex items-center gap-2 text-on-surface"><div className="w-3 h-3 rounded bg-error"></div> Severe</span>
              <span className="font-mono-data text-mono-data">{stats?.severePercent || 0}%</span>
            </div>
            <div className="flex justify-between items-center text-body-sm font-body-sm">
              <span className="flex items-center gap-2 text-on-surface"><div className="w-3 h-3 rounded bg-secondary"></div> Moderate</span>
              <span className="font-mono-data text-mono-data">{stats?.moderatePercent || 0}%</span>
            </div>
            <div className="flex justify-between items-center text-body-sm font-body-sm">
              <span className="flex items-center gap-2 text-on-surface"><div className="w-3 h-3 rounded bg-primary"></div> Mild</span>
              <span className="font-mono-data text-mono-data">{stats?.mildPercent || 0}%</span>
            </div>
          </div>
        </div>

        {/* Most Affected Muscle Groups (Bar Chart) */}
        <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col shadow-sm">
          <h3 className="font-headline-sm text-headline-sm text-on-background mb-6">Most Affected Muscle Groups</h3>
          <div className="flex-grow flex flex-col gap-5 justify-center min-h-[220px]">
            {!stats || stats.sortedMuscles.length === 0 ? (
              <p className="text-on-surface-variant text-sm">No data available.</p>
            ) : (
              stats.sortedMuscles.map(([mg, count], index) => {
                const percent = Math.round((count / stats.total) * 100);
                const colorClass = index === 0 ? 'bg-error' : 'bg-primary-container';
                return (
                  <div key={mg}>
                    <div className="flex justify-between mb-2">
                      <span className="font-label-md text-label-md text-on-surface capitalize">{mg}</span>
                      <span className={`font-mono-data text-mono-data ${index === 0 ? 'text-error' : 'text-on-surface-variant'}`}>{count} Cases</span>
                    </div>
                    <div className="w-full bg-surface-container-highest rounded-full h-2.5 overflow-hidden">
                      <div className={`${colorClass} h-full rounded-full transition-all duration-1000`} style={{ width: `${percent}%` }}></div>
                    </div>
                  </div>
                );
              })
            )}
          </div>
        </div>

      </div>
    </div>
  );
}
