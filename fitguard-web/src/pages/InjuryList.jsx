import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useInjuryStore } from '../store/injuryStore';

export default function InjuryList() {
  const { injuries, fetchInjuries, loading } = useInjuryStore();

  useEffect(() => {
    fetchInjuries();
  } // eslint-disable-next-line react-hooks/exhaustive-deps
  , []);

  const getSeverityColors = (severity) => {
    switch(severity?.toLowerCase()) {
      case 'high': return 'bg-error-container text-on-error-container';
      case 'moderate': return 'bg-[#fef08a] text-[#854d0e]';
      case 'low': return 'bg-primary-container text-on-primary-container';
      default: return 'bg-surface-variant text-on-surface-variant';
    }
  };

  return (
    <div className="max-w-container-max mx-auto h-full flex flex-col">
      {/* Page Header & Filters */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between mb-8 gap-4 shrink-0">
        <div>
          <h2 className="font-headline-lg text-headline-lg text-on-background">Injury Biometrics</h2>
          <p className="font-body-md text-body-md text-on-surface-variant mt-1">Comprehensive tracking and clinical status of active recovery protocols.</p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Link to="/injuries/create" className="flex items-center gap-2 bg-primary text-on-primary rounded-lg py-2 px-4 hover:bg-surface-tint transition-colors">
            <span className="material-symbols-outlined text-[18px]">add</span>
            <span className="font-label-md text-label-md">Log Injury</span>
          </Link>
        </div>
      </div>

      {loading && <p className="text-on-surface-variant text-center my-8">Loading biometrics...</p>}

      {!loading && injuries.length === 0 && (
        <div className="text-center py-12 bg-surface-container-lowest rounded-xl border border-surface-variant">
          <span className="material-symbols-outlined text-4xl text-on-surface-variant mb-4">healing</span>
          <h3 className="font-headline-sm text-on-surface">No Injuries Logged</h3>
          <p className="font-body-sm text-on-surface-variant mt-2 mb-6">You have no active or historical injuries.</p>
          <Link to="/injuries/create" className="bg-primary text-on-primary px-4 py-2 rounded-lg font-label-md">Log New Injury</Link>
        </div>
      )}

      {/* Bento Grid / Hybrid List View */}
      <div className="grid grid-cols-12 gap-6 pb-12">
        {injuries.map((injury, index) => {
          const isSevere = injury.severity?.toLowerCase() === 'high' || index === 0;

          if (isSevere && index === 0) {
            // Hero Card Layout
            return (
              <Link to={`/injuries/${injury.id}`} key={injury.id} className="col-span-12 lg:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 hover:border-outline transition-colors group cursor-pointer flex flex-col md:flex-row gap-6 relative overflow-hidden">
                <div className={`absolute left-0 top-0 bottom-0 w-1 ${injury.severity?.toLowerCase() === 'high' ? 'bg-error' : 'bg-primary'}`}></div>
                <div className="flex-1">
                  <div className="flex justify-between items-start mb-4">
                    <div>
                      <div className="flex items-center gap-2 mb-2">
                        <span className={`${getSeverityColors(injury.severity)} font-label-md text-[10px] px-2 py-1 rounded-full uppercase tracking-wider`}>{injury.severity} Risk</span>
                        <span className="text-on-surface-variant font-mono-data text-mono-data text-[12px]">{injury.id}</span>
                      </div>
                      <h3 className="font-headline-md text-headline-md text-on-background">{injury.injuryType}</h3>
                      <p className="font-body-sm text-body-sm text-on-surface-variant mt-1">{injury.muscleGroup} • {new Date(injury.dateOccurred).toLocaleDateString()}</p>
                    </div>
                  </div>
                  <div className="grid grid-cols-3 gap-4 border-t border-surface-variant pt-4 mt-2">
                    <div>
                      <p className="font-label-md text-[11px] text-on-surface-variant uppercase tracking-wider mb-1">Status</p>
                      <p className="font-body-sm text-body-sm font-medium flex items-center gap-1"><span className="material-symbols-outlined text-[16px]">local_hospital</span> Active Monitoring</p>
                    </div>
                    <div>
                      <p className="font-label-md text-[11px] text-on-surface-variant uppercase tracking-wider mb-1">Notes</p>
                      <p className="font-body-sm text-body-sm text-on-surface truncate">{injury.description || 'N/A'}</p>
                    </div>
                  </div>
                </div>
                {/* Mini Chart Area */}
                <div className="w-full md:w-[200px] bg-surface-container flex flex-col justify-end p-4 rounded-lg relative overflow-hidden h-32 md:h-auto">
                  <div className="absolute inset-0 opacity-20 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjEwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBkPSJNMCAxMDBMMjAgODBMODAgOTBMMTQwIDQwTDIwMCA2MCIgc3Ryb2tlPSIjYmExYTFhIiBzdHJva2Utd2lkdGg9IjIiIGZpbGw9Im5vbmUiLz48L3N2Zz4=')] bg-no-repeat bg-bottom bg-contain"></div>
                  <p className="font-label-md text-[10px] text-on-surface-variant uppercase tracking-wider relative z-10">Pain Index Trend</p>
                  <p className="font-headline-sm text-headline-sm text-tertiary relative z-10 mt-1">Tracking</p>
                </div>
              </Link>
            );
          }

          return (
            <Link to={`/injuries/${injury.id}`} key={injury.id} className="col-span-12 md:col-span-6 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 hover:border-outline hover:shadow-[0_4px_12px_rgba(0,0,0,0.03)] transition-all cursor-pointer group flex flex-col">
              <div className="flex justify-between items-start mb-4">
                <div className="flex items-center gap-2">
                  <span className={`${getSeverityColors(injury.severity)} font-label-md text-[10px] px-2 py-1 rounded-full uppercase tracking-wider`}>{injury.severity}</span>
                </div>
                <span className="text-on-surface-variant font-mono-data text-mono-data text-[12px]">{injury.id}</span>
              </div>
              <h3 className="font-headline-sm text-headline-sm text-on-background mb-1">{injury.injuryType}</h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-6">{injury.muscleGroup} • {new Date(injury.dateOccurred).toLocaleDateString()}</p>
              <div className="mt-auto space-y-3 border-t border-surface-variant pt-4">
                <div className="flex justify-between items-center">
                  <span className="font-label-md text-[11px] text-on-surface-variant uppercase">Recovery Status</span>
                  <span className="font-body-sm text-body-sm font-medium text-on-surface truncate ml-2">{injury.description || 'Monitoring'}</span>
                </div>
                <div className="w-full bg-surface-variant rounded-full h-1.5">
                  <div className="bg-primary h-1.5 rounded-full" style={{ width: '45%' }}></div>
                </div>
              </div>
            </Link>
          );
        })}

        {injuries.length > 0 && (
          <div className="col-span-12 lg:col-span-4 flex flex-col gap-6">
            {/* AI Insight Widget */}
            <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-5 shadow-sm relative overflow-hidden h-full flex flex-col">
              <div className="absolute top-0 right-0 p-4 opacity-10 pointer-events-none">
                <span className="material-symbols-outlined text-[64px] text-secondary">psychiatry</span>
              </div>
              <div className="flex items-center gap-2 mb-3">
                <span className="material-symbols-outlined text-secondary text-[20px]">smart_toy</span>
                <h4 className="font-label-md text-label-md text-secondary uppercase tracking-widest">AI Insight</h4>
              </div>
              <p className="font-body-sm text-body-sm text-on-surface-variant leading-relaxed flex-1">
                Analysis of biometric load data across 4 moderate cases indicates a 15% elevated risk of hamstring recurrence during eccentric loading phases. Recommend immediate protocol adjustment.
              </p>
              <Link to="/challenges/generate" className="mt-4 bg-secondary text-on-secondary font-label-md text-label-md py-2 px-4 rounded-lg hover:opacity-90 transition-opacity w-full text-center block">
                Generate Adjusted Protocol
              </Link>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
