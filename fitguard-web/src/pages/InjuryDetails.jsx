import { useEffect } from 'react';
import { Link, useParams } from 'react-router-dom';
import { useInjuryStore } from '../store/injuryStore';

export default function InjuryDetails() {
  const { id } = useParams();
  const { selectedInjury, fetchInjury, loading } = useInjuryStore();

  useEffect(() => {
    fetchInjury(id);
  }, [id, fetchInjury]);

  if (loading || !selectedInjury) {
    return <div className="p-8 text-center text-on-surface-variant">Loading injury details...</div>;
  }

  return (
    <div className="flex-1 p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full">
      {/* Breadcrumbs & Actions */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center mb-8 gap-4">
        <div>
          <div className="flex items-center space-x-2 text-body-sm text-on-surface-variant mb-2">
            <Link className="hover:text-primary transition-colors" to="/injuries">Recovery Plan</Link>
            <span className="material-symbols-outlined text-[16px]">chevron_right</span>
            <span className="text-on-background font-medium capitalize">{selectedInjury.injuryType}</span>
          </div>
          <div className="flex items-center gap-3">
            <h2 className="font-headline-lg text-headline-lg text-on-background capitalize">{selectedInjury.muscleGroup} {selectedInjury.injuryType}</h2>
            <span className="px-3 py-1 bg-error-container text-on-error-container font-label-md text-label-md rounded border border-error/20 uppercase">{selectedInjury.severity}</span>
          </div>
        </div>
        <div className="flex space-x-3 w-full sm:w-auto">
          <Link to={`/injuries/${id}/edit`} className="flex-1 sm:flex-none px-4 py-2 border border-outline-variant text-on-background font-label-md text-label-md rounded hover:border-outline transition-colors flex items-center justify-center gap-2">
            <span className="material-symbols-outlined text-[18px]">edit</span>
            Edit Details
          </Link>
          <button className="flex-1 sm:flex-none px-4 py-2 bg-primary text-on-primary font-label-md text-label-md rounded hover:opacity-90 transition-opacity shadow-sm flex items-center justify-center gap-2">
            <span className="material-symbols-outlined text-[18px]">add_task</span>
            Log Session
          </button>
        </div>
      </div>

      {/* Bento Grid Layout */}
      <div className="grid grid-cols-1 md:grid-cols-12 gap-gutter">
        
        {/* Clinical Summary Card (Spans 8 cols) */}
        <div className="md:col-span-8 bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
          <div className="flex justify-between items-center mb-6 border-b border-surface-container pb-4">
            <h3 className="font-headline-sm text-headline-sm text-on-background flex items-center gap-2">
              <span className="material-symbols-outlined text-primary">clinical_notes</span>
              Clinical Summary
            </h3>
            <span className="font-mono-data text-mono-data text-on-surface-variant">ID: {selectedInjury.id.substring(0,8)}</span>
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-6 mb-8">
            <div>
              <p className="font-label-md text-label-md text-on-surface-variant mb-1">MUSCLE GROUP</p>
              <p className="font-body-md text-body-md text-on-background font-medium capitalize">{selectedInjury.muscleGroup}</p>
            </div>
            <div>
              <p className="font-label-md text-label-md text-on-surface-variant mb-1">INJURY TYPE</p>
              <p className="font-body-md text-body-md text-on-background font-medium capitalize">{selectedInjury.injuryType}</p>
            </div>
            <div>
              <p className="font-label-md text-label-md text-on-surface-variant mb-1">DATE OF INJURY</p>
              <p className="font-body-md text-body-md text-on-background font-medium">{new Date(selectedInjury.dateOccurred).toLocaleDateString()}</p>
            </div>
            <div>
              <p className="font-label-md text-label-md text-on-surface-variant mb-1">STATUS</p>
              <p className="font-body-md text-body-md text-on-background font-medium capitalize">{selectedInjury.recoveryStatus}</p>
            </div>
          </div>
          <div>
            <p className="font-label-md text-label-md text-on-surface-variant mb-2">CLINICIAN NOTES</p>
            <p className="font-body-sm text-body-sm text-on-background leading-relaxed bg-surface-container-low p-4 rounded-lg border border-surface-container">
              {selectedInjury.notes || 'No notes provided.'}
            </p>
          </div>
        </div>

      </div>
    </div>
  );
}
