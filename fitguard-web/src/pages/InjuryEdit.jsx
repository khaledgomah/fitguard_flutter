import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { useInjuryStore } from '../store/injuryStore';

const injuryEditSchema = z.object({
  muscleGroup: z.string().optional(),
  injuryType: z.string().optional(),
  recoveryStatus: z.string().min(1, 'Status is required'),
  severity: z.number().min(1).max(10),
  dateOccurred: z.string().min(1, 'Date is required'),
  notes: z.string().min(1, 'Notes are required')
});

export default function InjuryEdit() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [serverError, setServerError] = useState('');

  const { selectedInjury, fetchInjury, updateInjury } = useInjuryStore();

  const { register, handleSubmit, watch, reset, formState: { errors } } = useForm({
    resolver: zodResolver(injuryEditSchema),
    defaultValues: {
      muscleGroup: '',
      injuryType: '',
      recoveryStatus: 'recovering',
      severity: 4,
      dateOccurred: '2023-11-04',
      notes: 'Patient shows 15% improvement in flexibility over last week. Slight pain reported during eccentric loading exercises. Recommending continued use of compression therapy post-workout and maintaining current physical therapy schedule. Avoid high-velocity sprinting for another 10 days.'
    }
  });

  useEffect(() => {
    if (id) {
      fetchInjury(id);
    }
  }, [id, fetchInjury]);

  useEffect(() => {
    if (selectedInjury) {
      let severityNum = 4;
      if (selectedInjury.severity === 'mild') severityNum = 2;
      else if (selectedInjury.severity === 'severe') severityNum = 9;

      reset({
        muscleGroup: selectedInjury.muscleGroup || '',
        injuryType: selectedInjury.injuryType || '',
        recoveryStatus: selectedInjury.recoveryStatus || 'active',
        severity: severityNum,
        dateOccurred: selectedInjury.dateOccurred ? new Date(selectedInjury.dateOccurred).toISOString().split('T')[0] : '',
        notes: selectedInjury.notes || ''
      });
    }
  }, [selectedInjury, reset]);

  /* eslint-disable-next-line react-hooks/incompatible-library */
  const severityValue = watch('severity');

  const onSubmit = async (data) => {
    try {
      setIsSubmitting(true);
      setServerError('');
      const payload = { ...data };
      if (payload.severity <= 3) payload.severity = 'mild';
      else if (payload.severity <= 7) payload.severity = 'moderate';
      else payload.severity = 'severe';

      await updateInjury(id, payload);
      navigate(`/injuries/${id}`);
    } catch (err) {
      setServerError(err.response?.data?.message || 'Failed to update injury.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="flex-1 p-6 md:p-8 max-w-[1000px] mx-auto w-full">
      {/* Breadcrumb & Header */}
      <div className="mb-8">
        <div className="flex items-center text-body-sm text-on-surface-variant mb-4 space-x-2">
          <Link className="hover:text-primary transition-colors" to="/injuries">Injuries</Link>
          <span className="material-symbols-outlined text-[16px]">chevron_right</span>
          <Link className="hover:text-primary transition-colors" to="/injuries">Injury Log</Link>
          <span className="material-symbols-outlined text-[16px]">chevron_right</span>
          <span className="text-on-surface font-medium">Edit Record {id ? `INJ-${id}` : 'INJ-0842'}</span>
        </div>
        <div className="flex justify-between items-end">
          <div>
            <h2 className="text-display-md font-display-md text-on-surface">Edit Injury Record</h2>
            <p className="text-body-lg text-on-surface-variant mt-1">Update clinical status and recovery metrics.</p>
          </div>
          <div className="hidden sm:flex space-x-3">
            <Link to={`/injuries/${id}`} className="px-4 py-2 border border-outline-variant rounded-lg text-body-sm font-medium text-on-surface hover:bg-surface-container-low transition-colors">
              Cancel
            </Link>
            <button 
              onClick={handleSubmit(onSubmit)}
              className="px-4 py-2 bg-primary text-white rounded-lg text-body-sm font-medium hover:bg-[#005a3c] transition-colors shadow-sm disabled:opacity-70 flex items-center gap-2"
              disabled={isSubmitting}
            >
              {isSubmitting && <span className="material-symbols-outlined animate-spin text-[16px]">progress_activity</span>}
              {isSubmitting ? 'Saving...' : 'Save Changes'}
            </button>
          </div>
        </div>
      </div>

      {serverError && (
        <div className="bg-error-container text-error p-3 rounded-xl flex items-center gap-2 mb-6">
          <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>error</span>
          <span className="font-body-sm text-body-sm">{serverError}</span>
        </div>
      )}

      {/* Main Form Card */}
      <div className="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-sm overflow-hidden mb-8">
        {/* Clinical Summary Header */}
        <div className="bg-surface-container-low p-6 border-b border-outline-variant flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <div className="flex items-center space-x-3 mb-1">
              <span className="material-symbols-outlined text-tertiary">sports_gymnastics</span>
              <h3 className="text-headline-sm font-headline-sm text-on-surface capitalize">{selectedInjury?.injuryType || 'Injury'}</h3>
            </div>
            <p className="text-body-sm text-on-surface-variant font-mono-data capitalize">{selectedInjury?.muscleGroup} • {selectedInjury?.injuryType} • Logged: {selectedInjury?.dateOccurred ? new Date(selectedInjury.dateOccurred).toLocaleDateString() : ''}</p>
          </div>
          <div className="flex items-center space-x-2 bg-white px-3 py-1.5 border border-outline-variant rounded-full">
            <div className="w-2 h-2 rounded-full bg-emerald-500"></div>
            <span className="text-label-md font-label-md text-on-surface">Active Tracking</span>
          </div>
        </div>

        <form className="p-6 md:p-8 space-y-8" onSubmit={handleSubmit(onSubmit)} noValidate>
          {/* Grid Layout for Inputs */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            
            {/* Recovery Status */}
            <div className="space-y-2">
              <label className="block text-label-md font-label-md text-on-surface uppercase" htmlFor="recoveryStatus">Recovery Status</label>
              <div className="relative">
                <select 
                  {...register('recoveryStatus')}
                  className={`w-full appearance-none clinical-input bg-white text-body-md text-on-surface rounded-lg py-3 pl-4 pr-10 ${errors.recoveryStatus ? 'border-error' : ''}`} 
                  id="recoveryStatus"
                >
                  <option value="active">Active Monitoring</option>
                  <option value="recovered">Recovered</option>
                </select>
                <span className="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-on-surface-variant pointer-events-none">expand_more</span>
              </div>
              <p className="text-body-sm text-on-surface-variant mt-1">Current clinical assessment phase.</p>
              {errors.recoveryStatus && <p className="text-error text-label-md">{errors.recoveryStatus.message}</p>}
            </div>

            {/* Severity Rating */}
            <div className="space-y-2">
              <label className="block text-label-md font-label-md text-on-surface uppercase" htmlFor="severity">Severity Rating (1-10)</label>
              <div className="flex items-center space-x-4">
                <input 
                  {...register('severity', { valueAsNumber: true })}
                  className="w-full h-2 bg-surface-container-highest rounded-lg appearance-none cursor-pointer accent-primary" 
                  id="severity" 
                  max="10" 
                  min="1" 
                  type="range" 
                />
                <div className="w-12 h-12 flex items-center justify-center bg-surface-container-low border border-outline-variant rounded-lg shrink-0">
                  <span className="text-headline-sm font-headline-sm text-primary font-mono-data">{severityValue}</span>
                </div>
              </div>
              <div className="flex justify-between text-label-md text-on-surface-variant px-1">
                <span>Mild (1)</span>
                <span>Severe (10)</span>
              </div>
              {errors.severity && <p className="text-error text-label-md">{errors.severity.message}</p>}
            </div>

            {/* Date of Assessment */}
            <div className="space-y-2">
              <label className="block text-label-md font-label-md text-on-surface uppercase" htmlFor="dateOccurred">Assessment Date</label>
              <input 
                {...register('dateOccurred')}
                className={`w-full clinical-input bg-white text-body-md text-on-surface rounded-lg py-3 px-4 ${errors.dateOccurred ? 'border-error' : ''}`} 
                id="dateOccurred" 
                type="date" 
              />
              {errors.dateOccurred && <p className="text-error text-label-md">{errors.dateOccurred.message}</p>}
            </div>

            {/* Attending Clinician */}
            <div className="space-y-2">
              <label className="block text-label-md font-label-md text-on-surface uppercase" htmlFor="clinician">Attending Clinician</label>
              <input 
                className="w-full clinical-input bg-white text-body-md text-on-surface rounded-lg py-3 px-4" 
                id="clinician" 
                type="text" 
                defaultValue="Dr. Sarah Jenkins"
              />
            </div>

          </div>

          <hr className="border-outline-variant" />

          {/* Clinical Notes */}
          <div className="space-y-2">
            <label className="block text-label-md font-label-md text-on-surface uppercase" htmlFor="notes">Clinical Notes</label>
            <textarea 
              {...register('notes')}
              className={`w-full clinical-input bg-white text-body-md text-on-surface rounded-lg py-3 px-4 resize-y ${errors.notes ? 'border-error' : ''}`} 
              id="notes" 
              rows="6"
            ></textarea>
            {errors.notes && <p className="text-error text-label-md">{errors.notes.message}</p>}
            <div className="flex justify-between items-center mt-2">
              <p className="text-body-sm text-on-surface-variant">Update detailing progress, pain levels, and treatment adjustments.</p>
              <button className="flex items-center space-x-1 text-violet-600 hover:text-violet-700 text-label-md font-label-md transition-colors" type="button">
                <span className="material-symbols-outlined text-[16px]">auto_awesome</span>
                <span>AI Summarize</span>
              </button>
            </div>
          </div>
          
          {/* Mobile Action Buttons (Sticky Bottom) - Inside form to use submit behavior, but for simplicity hiding or duplicating logic */}
        </form>

        <div className="sm:hidden bg-surface border-t border-outline-variant p-4 flex gap-3 sticky bottom-0">
          <Link to={`/injuries/${id}`} className="flex-1 py-3 border border-outline-variant rounded-lg text-body-md font-medium text-on-surface hover:bg-surface-container-low transition-colors text-center">
            Cancel
          </Link>
          <button 
            onClick={handleSubmit(onSubmit)}
            className="flex-1 py-3 bg-primary text-white rounded-lg text-body-md font-medium hover:bg-[#005a3c] transition-colors shadow-sm disabled:opacity-70"
            disabled={isSubmitting}
          >
            {isSubmitting ? 'Saving...' : 'Save'}
          </button>
        </div>

      </div>
    </div>
  );
}
