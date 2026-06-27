import { useInjuryStore } from '../../store/injuryStore';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';
import { Activity } from 'lucide-react';

export default function MuscleChart() {
  const injuries = useInjuryStore((state) => state.injuries);
  
  // تجميع الداتا عشان الرسم البياني
  const dataMap = injuries.reduce((acc, curr) => {
    acc[curr.muscleGroup] = (acc[curr.muscleGroup] || 0) + 1;
    return acc;
  }, {});
  
  const chartData = Object.keys(dataMap).map(key => ({
    name: key,
    count: dataMap[key]
  }));

  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100 h-80 flex flex-col">
      <h3 className="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
        <Activity className="text-secondary" size={20} /> Recurring Injury Pattern
      </h3>
      <div className="flex-1">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={chartData}>
            <XAxis dataKey="name" stroke="#64748b" />
            <YAxis allowDecimals={false} stroke="#64748b" />
            <Tooltip cursor={{fill: '#f1f5f9'}} />
            <Bar dataKey="count" fill="#7c3aed" radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
