import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useAuthStore } from '../store/authStore';
import { useProfileStore } from '../store/profileStore';

const passwordSchema = z.object({
  currentPassword: z.string().min(1, 'Current password is required'),
  newPassword: z.string().min(8, 'New password must be at least 8 characters'),
  confirmPassword: z.string().min(1, 'Please confirm your new password')
}).refine((data) => data.newPassword === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});

export default function Settings() {
  const { user, updatePassword } = useAuthStore();
  const { profile, fetchProfile, updateSettings } = useProfileStore();
  
  useEffect(() => {
    fetchProfile();
  }, [fetchProfile]);

  const { register, handleSubmit, reset, formState: { errors, isSubmitting } } = useForm({
    resolver: zodResolver(passwordSchema)
  });

  const onSubmitPassword = async (data) => {
    try {
      await updatePassword({ currentPassword: data.currentPassword, newPassword: data.newPassword });
      alert('Password updated successfully');
      reset();
    } catch (error) {
      alert(error.message || 'Failed to update password');
    }
  };

  if (!profile || !user) {
    return <div className="p-8 text-center">Loading settings...</div>;
  }

  return (
    <div className="flex-1 p-margin-mobile md:p-margin-desktop max-w-container-max mx-auto w-full">
      <div className="max-w-4xl mx-auto space-y-8">
        
        {/* Page Header */}
        <div>
          <h1 className="font-headline-lg text-headline-lg text-on-surface">Global Configuration</h1>
          <p className="font-body-md text-body-md text-on-surface-variant mt-2">Manage your security preferences and account settings.</p>
        </div>

        {/* Bento Grid Layout for Settings */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-6">
          
          {/* Left Column: Account & Security (Spans 12 cols, max width) */}
          <div className="lg:col-span-12 max-w-3xl space-y-6">
            
            {/* Account Information Card */}
            <section className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
              <div className="flex items-center justify-between mb-6">
                <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
                  <span className="material-symbols-outlined text-primary">person</span>
                  Account Information
                </h3>
                <Link to="/profile/edit" className="font-label-md text-label-md text-primary hover:text-primary-fixed-dim transition-colors">Edit</Link>
              </div>
              <div className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface-variant mb-1">First Name</label>
                    <input className="w-full px-4 py-2 bg-surface-container-low border border-surface-variant rounded-lg font-body-md text-body-md text-on-surface opacity-70" disabled type="text" value={profile.name.split(' ')[0] || ''} />
                  </div>
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface-variant mb-1">Last Name</label>
                    <input className="w-full px-4 py-2 bg-surface-container-low border border-surface-variant rounded-lg font-body-md text-body-md text-on-surface opacity-70" disabled type="text" value={profile.name.split(' ').slice(1).join(' ') || ''} />
                  </div>
                </div>
                <div>
                  <label className="block font-label-md text-label-md text-on-surface-variant mb-1">Email Address</label>
                  <input className="w-full px-4 py-2 bg-surface-container-low border border-surface-variant rounded-lg font-body-md text-body-md text-on-surface opacity-70" disabled type="email" value={profile.email} />
                </div>
              </div>
            </section>

            {/* Security Card */}
            <section className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
              <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2 mb-6">
                <span className="material-symbols-outlined text-primary">lock</span>
                Security
              </h3>
              <form onSubmit={handleSubmit(onSubmitPassword)} className="space-y-6">
                <div>
                  <label className="block font-label-md text-label-md text-on-surface-variant mb-1">Current Password</label>
                  <input 
                    {...register('currentPassword')}
                    className={`w-full px-4 py-2 bg-surface border ${errors.currentPassword ? 'border-error' : 'border-outline-variant'} rounded-lg font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all`} 
                    placeholder="••••••••••••" 
                    type="password" 
                  />
                  {errors.currentPassword && <p className="font-label-md text-[11px] text-error mt-1">{errors.currentPassword.message}</p>}
                </div>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface-variant mb-1">New Password</label>
                    <input 
                      {...register('newPassword')}
                      className={`w-full px-4 py-2 bg-surface border ${errors.newPassword ? 'border-error' : 'border-outline-variant'} rounded-lg font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all`} 
                      type="password" 
                    />
                    {errors.newPassword && <p className="font-label-md text-[11px] text-error mt-1">{errors.newPassword.message}</p>}
                  </div>
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface-variant mb-1">Confirm Password</label>
                    <input 
                      {...register('confirmPassword')}
                      className={`w-full px-4 py-2 bg-surface border ${errors.confirmPassword ? 'border-error' : 'border-outline-variant'} rounded-lg font-body-md text-body-md text-on-surface focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all`} 
                      type="password" 
                    />
                    {errors.confirmPassword && <p className="font-label-md text-[11px] text-error mt-1">{errors.confirmPassword.message}</p>}
                  </div>
                </div>
                <div className="flex justify-end pt-2">
                  <button 
                    disabled={isSubmitting}
                    className="px-6 py-2 bg-primary text-on-primary font-label-md text-label-md rounded-lg hover:bg-primary-container hover:text-on-primary-container transition-colors shadow-sm disabled:opacity-70 disabled:cursor-not-allowed"
                  >
                    {isSubmitting ? 'Updating...' : 'Update Password'}
                  </button>
                </div>
              </form>
            </section>
          </div>
        </div>
      </div>
    </div>
  );
}
