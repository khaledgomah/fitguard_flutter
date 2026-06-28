import { useState, useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useProfileStore } from '../store/profileStore';
import apiClient from '../services/apiClient';

const profileSchema = z.object({
  name: z.string().min(1, 'Full Name is required'),
  sport: z.string().min(1, 'Sport is required'),
  age: z.coerce.number().min(16, 'Must be at least 16').max(100, 'Must be under 100'),
  weight: z.coerce.number().min(30, 'Invalid weight').max(300, 'Invalid weight'),
  height: z.coerce.number().min(100, 'Invalid height').max(250, 'Invalid height'),
});

export default function ProfileEdit() {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [showToast, setShowToast] = useState(false);
  
  const { profile, updateProfile } = useProfileStore();

  const { register, handleSubmit, reset, formState: { errors } } = useForm({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      name: profile?.name || '',
      sport: profile?.sport || '',
      age: profile?.age || undefined,
      weight: profile?.weight || undefined,
      height: profile?.height || undefined,
    }
  });

  useEffect(() => {
    if (profile) {
      reset({
        name: profile.name,
        sport: profile.sport,
        age: profile.age,
        weight: profile.weight,
        height: profile.height
      });
    }
  }, [profile, reset]);

  const onSubmit = async (data) => {
    try {
      setIsSubmitting(true);
      await updateProfile(data);
      
      // Show Toast
      setShowToast(true);
      setTimeout(() => {
        setShowToast(false);
      }, 5000);
    } catch (error) {
      console.error('Failed to update profile', error);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="flex-1 overflow-y-auto p-margin-desktop bg-surface relative">
      <div className="max-w-[800px] mx-auto w-full">
        
        {/* Page Header */}
        <div className="mb-8">
          <h2 className="font-headline-lg text-headline-lg text-on-surface mb-2">Profile Settings</h2>
          <p className="font-body-md text-body-md text-on-surface-variant">Manage your clinical metrics and athlete profile data.</p>
        </div>

        {/* Main Form Card (Surface 1) */}
        <div className="bg-surface-container-lowest border border-outline-variant rounded-xl shadow-sm overflow-hidden">
          <form className="p-8 space-y-8" onSubmit={handleSubmit(onSubmit)} noValidate>
            
            {/* Avatar Section */}
            <div className="flex items-center gap-6 pb-8 border-b border-surface-container-high">
              <div className="relative w-24 h-24 rounded-full overflow-hidden border border-outline-variant bg-surface-container-low group cursor-pointer" onClick={() => document.getElementById('avatarUpload').click()}>
                <img 
                  alt="Current Profile Picture" 
                  className="w-full h-full object-cover group-hover:opacity-75 transition-opacity" 
                  src={profile?.avatarUrl || "https://lh3.googleusercontent.com/aida-public/AB6AXuBzkpif81MicB9laE_ctyLK-nanl1Huuevw-cnnhUbPbgKYCEkdiM3x3hDOvBp3OfpvNBuMWvj24hY8KHx5Tgqcsfd0I3JiIqi35t1bWrjDDWRyoXDNZUJ2rneuo0hLraIcOe2zBZv55nQ5aaxVHHYLv5Mb5e_I5fF2Z_xf7MzHm60uS59NXib4mMZXY9uDfRlKqsRYTcSsIvMyewqKxwy9sf53u5puNbKI8FgI5gURGh24fSSU-WwAzIqDeCV3VS_MSHYRuNN48rw"}
                />
                <div className="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity bg-on-background/20">
                  <span className="material-symbols-outlined text-white">photo_camera</span>
                </div>
              </div>
              <div>
                <h3 className="font-headline-sm text-headline-sm text-on-surface mb-1">Profile Picture</h3>
                <p className="font-body-sm text-body-sm text-on-surface-variant mb-3">High-resolution images help in visual gait analysis. JPG or PNG, max 5MB.</p>
                <input 
                  type="file" 
                  id="avatarUpload" 
                  className="hidden" 
                  accept="image/jpeg, image/png"
                  onChange={async (e) => {
                    const file = e.target.files[0];
                    if (!file) return;
                    const formData = new FormData();
                    formData.append('file', file);
                      try {
                        const res = await apiClient.post('/uploads', formData, {
                          headers: { 'Content-Type': 'multipart/form-data' }
                        });
                        
                        if (res.data && res.data.url) {
                          await updateProfile({ avatarUrl: res.data.url });
                          alert('Profile picture updated!');
                        } else {
                          alert('Upload failed: Missing URL from server');
                        }
                      } catch (err) {
                        console.error(err);
                        alert('Upload error: ' + (err.response?.data?.message || err.message));
                      }
                  }}
                />
                <button 
                  className="font-label-md text-label-md text-primary border border-primary px-4 py-2 rounded-lg hover:bg-primary hover:text-on-primary transition-colors inline-flex items-center gap-2" 
                  type="button"
                  onClick={() => document.getElementById('avatarUpload').click()}
                >
                  <span className="material-symbols-outlined text-[18px]">upload</span>
                  Upload New Photo
                </button>
              </div>
            </div>

            {/* Basic Info */}
            <div className="space-y-6">
              <h3 className="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Basic Information</h3>
              
              {/* Name Field */}
              <div className="flex flex-col gap-2">
                <label className="font-label-md text-label-md text-on-surface" htmlFor="name">Full Name</label>
                <input 
                  {...register('name')}
                  className={`w-full ${errors.name ? 'bg-error-container/20 border-error focus:ring-error' : 'bg-surface-bright border-outline-variant focus:border-primary focus:ring-primary'} border rounded-lg px-4 py-3 font-body-md text-body-md text-on-surface focus:outline-none focus:ring-1 transition-colors placeholder:text-on-surface-variant/50`} 
                  id="name" 
                  type="text" 
                />
                {errors.name && <span className="font-label-md text-[11px] text-error">{errors.name.message}</span>}
              </div>

              {/* Sport Dropdown */}
              <div className="flex flex-col gap-2">
                <label className="font-label-md text-label-md text-on-surface" htmlFor="sport">Primary Discipline</label>
                <div className="relative">
                  <select 
                    {...register('sport')}
                    className="w-full appearance-none bg-surface-bright border border-outline-variant rounded-lg px-4 py-3 font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-colors cursor-pointer" 
                    id="sport"
                  >
                    <option value="track">Track & Field (Sprint)</option>
                    <option value="marathon">Marathon</option>
                    <option value="cycling">Cycling (Road)</option>
                    <option value="triathlon">Triathlon</option>
                    <option value="swimming">Swimming</option>
                  </select>
                  <span className="material-symbols-outlined absolute right-4 top-1/2 -translate-y-1/2 text-on-surface-variant pointer-events-none">expand_more</span>
                </div>
                {errors.sport && <span className="font-label-md text-[11px] text-error">{errors.sport.message}</span>}
              </div>
            </div>

            {/* Biometrics Grid */}
            <div className="space-y-6 pt-6 border-t border-surface-container-high">
              <h3 className="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider flex justify-between items-center">
                Baseline Biometrics
                <span className="text-[10px] text-on-surface-variant/70 normal-case bg-surface-container px-2 py-1 rounded">Used for AI baselines</span>
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                
                {/* Age Field */}
                <div className="flex flex-col gap-2 relative">
                  <label className="font-label-md text-label-md text-on-surface" htmlFor="age">Age</label>
                  <div className="relative group">
                    <input 
                      {...register('age', { valueAsNumber: true })}
                      className={`w-full ${errors.age ? 'bg-error-container/20 border-error focus:ring-error' : 'bg-surface-bright border-outline-variant focus:border-primary focus:ring-primary'} border rounded-lg px-4 py-3 font-mono-data text-mono-data text-on-surface focus:outline-none focus:ring-1 transition-colors pr-12`} 
                      id="age" 
                      type="number" 
                    />
                    <span className="absolute right-4 top-1/2 -translate-y-1/2 font-label-md text-label-md text-on-surface-variant">yrs</span>
                    {errors.age && <span className="material-symbols-outlined absolute right-10 top-1/2 -translate-y-1/2 text-error text-[18px]">error</span>}
                  </div>
                  {errors.age && <span className="font-label-md text-[11px] text-error absolute -bottom-5 left-0">{errors.age.message}</span>}
                </div>

                {/* Weight Field */}
                <div className="flex flex-col gap-2 relative">
                  <label className="font-label-md text-label-md text-on-surface" htmlFor="weight">Body Mass</label>
                  <div className="relative group">
                    <input 
                      {...register('weight', { valueAsNumber: true })}
                      className={`w-full ${errors.weight ? 'bg-error-container/20 border-error focus:ring-error' : 'bg-surface-bright border-outline-variant focus:border-primary focus:ring-primary'} border rounded-lg px-4 py-3 font-mono-data text-mono-data text-on-surface focus:outline-none focus:ring-1 transition-colors pr-12`} 
                      id="weight" 
                      type="number" 
                      step="0.1" 
                    />
                    <span className="absolute right-4 top-1/2 -translate-y-1/2 font-label-md text-label-md text-on-surface-variant">kg</span>
                    {errors.weight && <span className="material-symbols-outlined absolute right-10 top-1/2 -translate-y-1/2 text-error text-[18px]">error</span>}
                  </div>
                  {errors.weight && <span className="font-label-md text-[11px] text-error absolute -bottom-5 left-0">{errors.weight.message}</span>}
                </div>

                {/* Height Field */}
                <div className="flex flex-col gap-2 relative">
                  <label className="font-label-md text-label-md text-on-surface" htmlFor="height">Height</label>
                  <div className="relative group">
                    <input 
                      {...register('height', { valueAsNumber: true })}
                      className={`w-full ${errors.height ? 'bg-error-container/20 border-error focus:ring-error' : 'bg-surface-bright border-outline-variant focus:border-primary focus:ring-primary'} border rounded-lg px-4 py-3 font-mono-data text-mono-data text-on-surface focus:outline-none focus:ring-1 transition-colors pr-12`} 
                      id="height" 
                      type="number" 
                    />
                    <span className="absolute right-4 top-1/2 -translate-y-1/2 font-label-md text-label-md text-on-surface-variant">cm</span>
                    {errors.height && <span className="material-symbols-outlined absolute right-10 top-1/2 -translate-y-1/2 text-error text-[18px]">error</span>}
                  </div>
                  {errors.height && <span className="font-label-md text-[11px] text-error absolute -bottom-5 left-0">{errors.height.message}</span>}
                </div>
              </div>
            </div>

            {/* Form Actions */}
            <div className="pt-8 flex items-center justify-end gap-4 border-t border-surface-container-high mt-8">
              <button className="px-6 py-2.5 rounded-lg font-label-md text-label-md text-on-surface border border-outline-variant hover:bg-surface-container-low transition-colors" type="button">
                Discard Changes
              </button>
              <button 
                className={`px-6 py-2.5 rounded-lg font-label-md text-label-md text-on-primary bg-primary transition-all flex items-center justify-center min-w-[160px] relative overflow-hidden group ${isSubmitting ? 'opacity-90 cursor-not-allowed' : 'hover:bg-primary/90'}`} 
                type="submit"
                disabled={isSubmitting}
              >
                <span className={`transition-opacity duration-200 ${isSubmitting ? 'opacity-0' : 'opacity-100'}`}>Save Profile Metrics</span>
                {/* Loading Spinner */}
                <svg className={`spinner w-5 h-5 absolute transition-opacity duration-200 ${isSubmitting ? 'opacity-100' : 'opacity-0'}`} viewBox="0 0 50 50">
                  <circle className="path" cx="25" cy="25" r="20" fill="none" strokeWidth="5" stroke="currentColor"></circle>
                </svg>
              </button>
            </div>

          </form>
        </div>

        {/* Bottom spacer for scrolling */}
        <div className="h-24"></div>
      </div>

      {/* Success Toast Notification */}
      <div 
        className={`fixed bottom-margin-desktop right-margin-desktop bg-inverse-surface text-inverse-on-surface border border-on-background/10 shadow-lg rounded-xl p-4 flex items-start gap-3 z-50 max-w-sm transition-all duration-300 ${showToast ? 'translate-y-0 opacity-100' : 'translate-y-full opacity-0'}`} 
        aria-hidden={!showToast}
      >
        <div className="bg-primary/20 text-primary-fixed p-1 rounded-full shrink-0 flex items-center justify-center">
          <span className="material-symbols-outlined text-[18px]">check</span>
        </div>
        <div>
          <h4 className="font-label-md text-label-md mb-0.5 text-white">Clinical Data Synced</h4>
          <p className="font-body-sm text-body-sm text-inverse-on-surface/80">Your profile metrics have been successfully updated to the secure ledger.</p>
        </div>
        <button className="ml-2 text-inverse-on-surface/60 hover:text-white shrink-0 transition-colors" onClick={() => setShowToast(false)}>
          <span className="material-symbols-outlined text-[18px]">close</span>
        </button>
      </div>

    </div>
  );
}
