import { useState } from 'react';
import { useInjuryStore } from '../../store/injuryStore';
import { PlusCircle } from 'lucide-react';

export default function InjuryForm() {
  const createInjury = useInjuryStore((state) => state.createInjury);
  const [formData, setFormData] = useState({ muscleGroup: '', severity: 'Low', injuryType: 'Muscle' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.muscleGroup) return;
    await createInjury({ 
      muscleGroup: formData.muscleGroup,
      injuryType: formData.injuryType,
      severity: formData.severity.toLowerCase() === 'low' ? 'mild' : formData.severity.toLowerCase() === 'medium' ? 'moderate' : 'severe',
      dateOccurred: new Date().toISOString(),
      recoveryStatus: 'active'
    });
    setFormData({ muscleGroup: '', severity: 'Low', injuryType: 'Muscle' });
  };

  return (
    <div className="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
      <h3 className="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
        <PlusCircle className="text-danger" size={20} /> Log New Injury
      </h3>
      <form onSubmit={handleSubmit} className="flex flex-col gap-4">
        <input 
          type="text" 
          placeholder="Affected Muscle (e.g., Knee)" 
          className="border p-2 rounded-lg w-full focus:outline-none focus:border-primary"
          value={formData.muscleGroup}
          onChange={(e) => setFormData({ ...formData, muscleGroup: e.target.value })}
        />
        <select 
          className="border p-2 rounded-lg w-full focus:outline-none focus:border-primary"
          value={formData.severity}
          onChange={(e) => setFormData({ ...formData, severity: e.target.value })}
        >
          <option value="Low">Low Severity</option>
          <option value="Medium">Medium Severity</option>
          <option value="High">High Severity</option>
        </select>
        <button type="submit" className="bg-danger text-white p-2 rounded-lg font-bold hover:bg-rose-600 transition-colors">
          Save Record
        </button>
      </form>
    </div>
  );
}
