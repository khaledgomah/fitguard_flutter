import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useNavigate } from 'react-router-dom';
import { useInjuryStore } from '../store/injuryStore';

const injurySchema = z.object({
  muscleGroup: z.string().min(1, 'Muscle Group is required'),
  injuryType: z.string().min(1, 'Injury Type is required'),
  notes: z.string().optional(),
  severity: z.enum(['mild', 'moderate', 'severe'], { required_error: 'Severity is required' }),
  dateOccurred: z.string().min(1, 'Date & Time is required')
});

export default function InjuryCreate() {
  const navigate = useNavigate();
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [serverError, setServerError] = useState('');
  
  const { createInjury } = useInjuryStore();

  const { register, handleSubmit, watch, formState: { errors } } = useForm({
    resolver: zodResolver(injurySchema),
    defaultValues: {
      muscleGroup: '',
      injuryType: '',
      notes: '',
      severity: undefined,
      dateOccurred: ''
    }
  });

  /* eslint-disable-next-line react-hooks/incompatible-library */
  const severityValue = watch('severity');

  const onSubmit = async (data) => {
    try {
      setIsSubmitting(true);
      setServerError('');
      await createInjury(data);
      navigate('/injuries');
    } catch (err) {
      setServerError(err.response?.data?.message || 'Failed to log injury.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="p-margin-desktop min-h-[calc(100vh-64px)]">
      <div className="max-w-4xl mx-auto">
        
        {/* Page Header */}
        <div className="mb-8 flex items-end justify-between">
          <div>
            <div className="flex items-center space-x-2 text-error mb-2">
              <span className="material-symbols-outlined text-[20px]" style={{ fontVariationSettings: "'FILL' 1" }}>emergency</span>
              <span className="font-label-md text-label-md uppercase tracking-widest text-error">Clinical Logging</span>
            </div>
            <h2 className="font-display-md text-display-md text-on-surface mb-2">Log New Injury</h2>
            <p className="font-body-md text-body-md text-on-surface-variant">Accurate reporting ensures precise recovery protocol generation.</p>
          </div>
          <div className="hidden md:block text-right">
            <p className="font-mono-data text-mono-data text-on-surface-variant">Protocol ID: <span className="text-on-surface">INJ-0924</span></p>
            <p className="font-mono-data text-mono-data text-on-surface-variant">System Status: <span className="text-primary">Online</span></p>
          </div>
        </div>

        {/* Bento Layout for Form */}
        <form onSubmit={handleSubmit(onSubmit)} className="grid grid-cols-1 md:grid-cols-12 gap-gutter" noValidate>
          
          {/* Left Column: Primary Details */}
          <div className="md:col-span-8 space-y-gutter">
            
            {/* Clinical Card: Core Data */}
            <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
              <h3 className="font-headline-sm text-headline-sm text-on-surface mb-6 flex items-center border-b border-surface-variant pb-4">
                <span className="material-symbols-outlined mr-2 text-on-surface-variant">body_system</span>
                Anatomical Focus
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Muscle Group */}
                <div>
                  <label className="block font-label-md text-label-md text-on-surface-variant mb-2" htmlFor="muscleGroup">Muscle Group / Area</label>
                  <select 
                    {...register('muscleGroup')}
                    className={`w-full clinical-input rounded-lg py-2.5 px-3 font-body-sm text-body-sm text-on-surface focus:ring-0 ${errors.muscleGroup ? 'border-error' : ''}`} 
                    id="muscleGroup"
                  >
                    <option disabled value="">Select anatomical region...</option>
                    <optgroup label="Lower Extremity">
                      <option value="hamstring">Hamstring</option>
                      <option value="quadriceps">Quadriceps</option>
                      <option value="calf">Calf / Achilles</option>
                      <option value="knee">Knee Joint</option>
                      <option value="ankle">Ankle</option>
                    </optgroup>
                    <optgroup label="Upper Extremity">
                      <option value="shoulder">Shoulder / Rotator Cuff</option>
                      <option value="elbow">Elbow</option>
                      <option value="wrist">Wrist / Hand</option>
                    </optgroup>
                    <optgroup label="Core & Spine">
                      <option value="lower_back">Lower Back (Lumbar)</option>
                      <option value="upper_back">Upper Back (Thoracic)</option>
                      <option value="neck">Neck (Cervical)</option>
                      <option value="abdomen">Abdominal</option>
                    </optgroup>
                  </select>
                  {errors.muscleGroup && <p className="font-label-md text-[11px] text-error mt-1">{errors.muscleGroup.message}</p>}
                </div>
                
                {/* Injury Type */}
                <div>
                  <label className="block font-label-md text-label-md text-on-surface-variant mb-2" htmlFor="injuryType">Pathology Classification</label>
                  <select 
                    {...register('injuryType')}
                    className={`w-full clinical-input rounded-lg py-2.5 px-3 font-body-sm text-body-sm text-on-surface focus:ring-0 ${errors.injuryType ? 'border-error' : ''}`} 
                    id="injuryType"
                  >
                    <option disabled value="">Select injury type...</option>
                    <option value="strain">Muscle Strain (Tear)</option>
                    <option value="sprain">Ligament Sprain</option>
                    <option value="contusion">Contusion (Bruise)</option>
                    <option value="tendinitis">Tendinopathy / Tendinitis</option>
                    <option value="fracture">Fracture (Bone)</option>
                    <option value="dislocation">Dislocation / Subluxation</option>
                    <option value="laceration">Laceration</option>
                  </select>
                  {errors.injuryType && <p className="font-label-md text-[11px] text-error mt-1">{errors.injuryType.message}</p>}
                </div>
              </div>
            </div>

            {/* Clinical Card: Clinical Notes */}
            <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
              <h3 className="font-headline-sm text-headline-sm text-on-surface mb-4 flex items-center">
                <span className="material-symbols-outlined mr-2 text-on-surface-variant">clinical_notes</span>
                Clinical Notes
              </h3>
              <p className="font-body-sm text-body-sm text-on-surface-variant mb-4">Provide detailed context regarding the mechanism of injury (MOI), immediate symptoms, and any immediate treatments applied (e.g., RICE protocol).</p>
              <textarea 
                {...register('notes')}
                className="w-full clinical-input rounded-lg p-4 font-body-sm text-body-sm text-on-surface focus:ring-0 resize-y" 
                id="notes" 
                placeholder="Mechanism of injury: e.g., 'Felt a sharp pull in distal hamstring during explosive sprint acceleration phase...'" 
                rows="6"
              ></textarea>

            </div>

          </div>

          {/* Right Column: Severity & Meta */}
          <div className="md:col-span-4 space-y-gutter">
            
            {/* Severity Card (High Visual Priority) */}
            <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm relative overflow-hidden">
              {/* Decorative subtle gradient to hint at danger/alert */}
              <div className="absolute top-0 right-0 w-32 h-32 bg-error opacity-5 rounded-full blur-3xl -mr-16 -mt-16 pointer-events-none"></div>
              <h3 className="font-headline-sm text-headline-sm text-on-surface mb-6 flex items-center">
                <span className="material-symbols-outlined mr-2 text-error" style={{ fontVariationSettings: "'FILL' 1" }}>warning</span>
                Severity Index
              </h3>
              <div className="space-y-3">
                
                {/* Mild */}
                <label className="cursor-pointer relative block">
                  <input {...register('severity')} className="peer sr-only severity-radio" type="radio" value="mild" />
                  <div className="severity-radio-label w-full border border-outline-variant rounded-lg p-4 flex items-center hover:bg-surface-container-low">
                    <div className={`flex-shrink-0 w-4 h-4 rounded-full border border-outline-variant mr-3 flex items-center justify-center ${severityValue === 'mild' ? 'bg-error border-error' : ''}`}>
                      <div className={`w-2 h-2 rounded-full bg-white ${severityValue === 'mild' ? 'opacity-100' : 'opacity-0'}`}></div>
                    </div>
                    <div>
                      <span className="block font-body-sm text-body-sm font-semibold">Grade I (Mild)</span>
                      <span className="block font-label-md text-label-md text-on-surface-variant font-normal mt-0.5">Micro-tearing, minimal loss of function.</span>
                    </div>
                  </div>
                </label>
                
                {/* Moderate */}
                <label className="cursor-pointer relative block">
                  <input {...register('severity')} className="peer sr-only severity-radio" type="radio" value="moderate" />
                  <div className="severity-radio-label w-full border border-outline-variant rounded-lg p-4 flex items-center hover:bg-surface-container-low">
                    <div className={`flex-shrink-0 w-4 h-4 rounded-full border border-outline-variant mr-3 flex items-center justify-center ${severityValue === 'moderate' ? 'bg-error border-error' : ''}`}>
                      <div className={`w-2 h-2 rounded-full bg-white ${severityValue === 'moderate' ? 'opacity-100' : 'opacity-0'}`}></div>
                    </div>
                    <div>
                      <span className="block font-body-sm text-body-sm font-semibold">Grade II (Moderate)</span>
                      <span className="block font-label-md text-label-md text-on-surface-variant font-normal mt-0.5">Partial tear, significant pain, swelling.</span>
                    </div>
                  </div>
                </label>
                
                {/* Severe */}
                <label className="cursor-pointer relative block">
                  <input {...register('severity')} className="peer sr-only severity-radio" type="radio" value="severe" />
                  <div className="severity-radio-label w-full border border-outline-variant rounded-lg p-4 flex items-center hover:bg-surface-container-low">
                    <div className={`flex-shrink-0 w-4 h-4 rounded-full border border-outline-variant mr-3 flex items-center justify-center ${severityValue === 'severe' ? 'bg-error border-error' : ''}`}>
                      <div className={`w-2 h-2 rounded-full bg-white ${severityValue === 'severe' ? 'opacity-100' : 'opacity-0'}`}></div>
                    </div>
                    <div>
                      <span className="block font-body-sm text-body-sm font-semibold">Grade III (Severe)</span>
                      <span className="block font-label-md text-label-md text-on-surface-variant font-normal mt-0.5">Complete rupture, loss of structural integrity.</span>
                    </div>
                  </div>
                </label>

              </div>
              {errors.severity && <p className="font-label-md text-[11px] text-error mt-2">{errors.severity.message}</p>}
            </div>

            {/* Date & Meta Card */}
            <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
              <h3 className="font-headline-sm text-headline-sm text-on-surface mb-4 flex items-center">
                <span className="material-symbols-outlined mr-2 text-on-surface-variant">calendar_month</span>
                Incident Meta
              </h3>
              <div className="space-y-4">
                <div>
                  <label className="block font-label-md text-label-md text-on-surface-variant mb-2" htmlFor="dateOccurred">Date & Time of Incident</label>
                  <input 
                    {...register('dateOccurred')}
                    className={`w-full clinical-input rounded-lg py-2.5 px-3 font-body-sm text-body-sm text-on-surface focus:ring-0 ${errors.dateOccurred ? 'border-error' : ''}`} 
                    id="dateOccurred" 
                    type="datetime-local" 
                  />
                  {errors.dateOccurred && <p className="font-label-md text-[11px] text-error mt-1">{errors.dateOccurred.message}</p>}
                </div>

              </div>
            </div>

            {/* Submission Actions */}
            <div className="pt-4">
              {serverError && (
                <div className="bg-error-container text-error p-3 rounded-xl flex items-center gap-2 mb-4">
                  <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>error</span>
                  <span className="font-body-sm text-body-sm">{serverError}</span>
                </div>
              )}
              <button 
                className="w-full bg-error text-on-error font-headline-sm text-headline-sm py-4 rounded-xl shadow-sm hover:opacity-90 hover:shadow-md transition-all flex items-center justify-center space-x-2 disabled:opacity-70 disabled:cursor-not-allowed" 
                type="submit"
                disabled={isSubmitting}
              >
                <span className="material-symbols-outlined">save</span>
                <span>{isSubmitting ? 'Committing...' : 'Commit Clinical Record'}</span>
              </button>

            </div>

          </div>
        </form>
      </div>
    </div>
  );
}
