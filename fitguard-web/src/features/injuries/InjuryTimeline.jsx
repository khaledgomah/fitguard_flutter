import { useInjuryStore } from '../../store/injuryStore';
import { Clock } from 'lucide-react';

export default function InjuryTimeline() {
  const injuries = useInjuryStore((state) => state.injuries);
  const formatDate = (dateStr) => {
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) return dateStr;
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
      <h3 className="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
        <Clock className="text-primary" size={20} /> Injury History
      </h3>
      <div className="flex flex-col gap-4 border-l-2 border-slate-200 ml-3 pl-4">
        {injuries.map((inj) => (
          <div key={inj.id} className="relative">
            <div className="absolute -left-[23px] top-1 w-3 h-3 bg-white border-2 border-primary rounded-full"></div>
            <p className="font-bold text-slate-700">{inj.muscleGroup} <span className="text-xs font-normal text-slate-400 ml-2">{formatDate(inj.dateOccurred)}</span></p>
            <p className="text-sm text-slate-500">Severity: <span className={inj.severity.toLowerCase() === 'severe' || inj.severity.toLowerCase() === 'high' ? 'text-danger font-medium' : ''}>{inj.severity}</span> • Status: {inj.recoveryStatus || 'active'}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
