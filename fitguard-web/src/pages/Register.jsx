import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useNavigate, Link } from 'react-router-dom';
import { authService } from '../services/authService';

const registerSchema = z.object({
  name: z.string().min(2, 'Full Legal Name is required'),
  email: z.string().email('Please enter a valid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  sport: z.string().min(1, 'Please select a discipline'),
  age: z.coerce.number().min(10, 'Must be a valid age'),
  weight: z.coerce.number().min(30, 'Must be a valid weight'),
  height: z.coerce.number().min(100, 'Must be a valid height')
});

export default function Register() {
  const navigate = useNavigate();
  const [serverError, setServerError] = useState('');
  const [success, setSuccess] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting }
  } = useForm({
    resolver: zodResolver(registerSchema)
  });

  const onSubmit = async (data) => {
    try {
      setServerError('');
      await authService.register(data);
      
      setSuccess(true);
      setTimeout(() => {
        navigate('/login', { replace: true });
      }, 3000); // give time to read success state
    } catch (err) {
      setServerError(err.response?.data?.message || 'An error occurred during registration');
    }
  };

  return (
    <div className="min-h-screen flex w-full relative overflow-hidden bg-surface text-on-surface antialiased selection:bg-primary-container selection:text-on-primary font-body-md">
      {/* Left Side: Motivational Imagery (Hidden on Mobile) */}
      <div className="hidden lg:flex lg:w-[45%] xl:w-1/2 relative bg-inverse-surface items-end justify-start overflow-hidden">
        {/* Background Image */}
        <div 
          className="absolute inset-0 bg-cover bg-center object-cover opacity-80" 
          style={{ backgroundImage: "url('https://lh3.googleusercontent.com/aida-public/AB6AXuBPTCrRTHnbIo25jVGHO8FPCozfWOO_3Hm_gpD27sIhqv3Iyb_IOZFmaWQ_3jpp4yTQOrQtgpmlg49iABDJ8XA5sjZf95FXertwjxQqzDI8iuBR0rXlDUldfeWJgmg6cPMg_3E4B5UhyqBLtn-NL4zYSkd9plZYCWKaxT7DMFo3Xbczs2Y3d5QlbqUaEv78t3UjN1cwuF0N6YmBWGfGFZoJY8zgO0rc2Ve1yLs3fxtcEYl5Kcn4pg3CSDTUuBLpT7n0i6t4HRYMBSg')" }}
        ></div>
        
        {/* Gradient Overlay for Text Readability */}
        <div className="absolute inset-0 bg-gradient-to-t from-background via-background/40 to-transparent"></div>
        
        {/* Brand & Motivation Content */}
        <div className="relative z-10 p-12 xl:p-24 w-full">
          <div className="flex items-center space-x-2 mb-12">
            <span className="material-symbols-outlined text-primary-fixed-dim text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>
              monitor_heart
            </span>
            <span className="font-headline-sm text-headline-sm font-bold tracking-tight text-white">FitGuard AI</span>
          </div>
          <h1 className="font-display-lg text-display-lg text-white mb-6">
            Clinical Precision.<br/>
            <span className="text-primary-fixed-dim">Elite Performance.</span>
          </h1>
          <p className="font-body-lg text-body-lg text-surface-dim max-w-md">
            Join the premier platform for data-driven athletic recovery. Analyze biometrics, prevent injuries, and optimize your physical output.
          </p>
          
          {/* Trust indicators */}
          <div className="mt-12 flex space-x-6">
            <div className="flex items-center space-x-2">
              <span className="material-symbols-outlined text-outline-variant" style={{ fontVariationSettings: "'FILL' 1" }}>verified_user</span>
              <span className="font-label-md text-label-md text-outline-variant uppercase">HIPAA Compliant</span>
            </div>
            <div className="flex items-center space-x-2">
              <span className="material-symbols-outlined text-outline-variant" style={{ fontVariationSettings: "'FILL' 1" }}>speed</span>
              <span className="font-label-md text-label-md text-outline-variant uppercase">Real-time Telemetry</span>
            </div>
          </div>
        </div>
      </div>

      {/* Right Side: Registration Flow */}
      <div className="w-full lg:w-[55%] xl:w-1/2 flex items-center justify-center p-6 sm:p-12 lg:p-16 bg-surface overflow-y-auto relative">
        {/* Main Container */}
        <div className="w-full max-w-[480px] relative">
          
          {/* Form View */}
          <div className={`transition-all duration-300 ${success ? 'opacity-0 hidden' : 'opacity-100'}`}>
            {/* Mobile Brand Header */}
            <div className="lg:hidden flex items-center justify-center space-x-2 mb-10">
              <span className="material-symbols-outlined text-primary text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>monitor_heart</span>
              <span className="font-headline-sm text-headline-sm font-bold tracking-tight text-on-surface">FitGuard</span>
            </div>
            <div className="mb-8">
              <h2 className="font-display-md text-display-md text-on-surface mb-2">Create Account</h2>
              <p className="font-body-md text-body-md text-on-surface-variant">Enter your details to configure your clinical profile.</p>
            </div>
            
            <form className="space-y-8" onSubmit={handleSubmit(onSubmit)} noValidate>
              
              {/* Group 1: Account Information */}
              <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
                <h3 className="font-label-md text-label-md text-on-surface uppercase tracking-wider mb-5 flex items-center">
                  <span className="material-symbols-outlined mr-2 text-primary" style={{ fontSize: '18px' }}>account_circle</span>
                  Identity
                </h3>
                <div className="space-y-4">
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="name">Full Legal Name</label>
                    <input 
                      className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-body-md placeholder-on-surface-variant transition-all" 
                      id="name" 
                      placeholder="Your Name" 
                      type="text"
                      {...register('name')}
                    />
                    {errors.name && <p className="text-error text-body-sm mt-1">{errors.name.message}</p>}
                  </div>
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="email">Professional Email</label>
                    <input 
                      className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-body-md placeholder-on-surface-variant transition-all" 
                      id="email" 
                      placeholder="your@email.com" 
                      type="email"
                      {...register('email')}
                    />
                    {errors.email && <p className="text-error text-body-sm mt-1">{errors.email.message}</p>}
                  </div>
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="password">Secure Password</label>
                    <input 
                      className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-body-md placeholder-on-surface-variant transition-all" 
                      id="password" 
                      placeholder="••••••••" 
                      type="password"
                      {...register('password')}
                    />
                    {errors.password && <p className="text-error text-body-sm mt-1">{errors.password.message}</p>}
                  </div>
                </div>
              </div>

              {/* Group 2: Biometric Baseline */}
              <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 shadow-sm">
                <h3 className="font-label-md text-label-md text-on-surface uppercase tracking-wider mb-5 flex items-center">
                  <span className="material-symbols-outlined mr-2 text-primary" style={{ fontSize: '18px' }}>vital_signs</span>
                  Biometric Baseline
                </h3>
                <div className="space-y-5">
                  <div>
                    <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="sport">Primary Discipline</label>
                    <div className="relative">
                      <select 
                        className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-body-md appearance-none transition-all" 
                        id="sport"
                        defaultValue=""
                        {...register('sport')}
                      >
                        <option disabled value="">Select a discipline</option>
                        <option value="athletics">Athletics / Track</option>
                        <option value="basketball">Basketball</option>
                        <option value="cycling">Cycling</option>
                        <option value="football">Football / Soccer</option>
                        <option value="weightlifting">Olympic Weightlifting</option>
                        <option value="tennis">Tennis</option>
                      </select>
                      <span className="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-on-surface-variant pointer-events-none">expand_more</span>
                    </div>
                    {errors.sport && <p className="text-error text-body-sm mt-1">{errors.sport.message}</p>}
                  </div>
                  
                  <div className="grid grid-cols-3 gap-4">
                    <div>
                      <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="age">Age</label>
                      <div className="relative">
                        <input 
                          className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-mono-data pr-8 transition-all" 
                          id="age" 
                          placeholder="00" 
                          type="number"
                          {...register('age')}
                        />
                        <span className="absolute right-3 top-1/2 -translate-y-1/2 font-label-md text-label-md text-on-surface-variant">Yrs</span>
                      </div>
                      {errors.age && <p className="text-error text-[11px] mt-1">{errors.age.message}</p>}
                    </div>
                    <div>
                      <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="weight">Weight</label>
                      <div className="relative">
                        <input 
                          className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-mono-data pr-8 transition-all" 
                          id="weight" 
                          placeholder="00.0" 
                          type="number" step="0.1"
                          {...register('weight')}
                        />
                        <span className="absolute right-3 top-1/2 -translate-y-1/2 font-label-md text-label-md text-on-surface-variant">kg</span>
                      </div>
                      {errors.weight && <p className="text-error text-[11px] mt-1">{errors.weight.message}</p>}
                    </div>
                    <div>
                      <label className="block font-label-md text-label-md text-on-surface mb-1.5" htmlFor="height">Height</label>
                      <div className="relative">
                        <input 
                          className="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-3 text-on-surface focus:outline-none focus:bg-surface focus:border-primary focus:ring-1 focus:ring-primary font-mono-data pr-8 transition-all" 
                          id="height" 
                          placeholder="000" 
                          type="number"
                          {...register('height')}
                        />
                        <span className="absolute right-3 top-1/2 -translate-y-1/2 font-label-md text-label-md text-on-surface-variant">cm</span>
                      </div>
                      {errors.height && <p className="text-error text-[11px] mt-1">{errors.height.message}</p>}
                    </div>
                  </div>
                </div>
              </div>

              {/* Server Error */}
              {serverError && (
                <div className="bg-error-container text-error p-3 rounded-xl flex items-center gap-2">
                  <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>error</span>
                  <span className="font-body-sm text-body-sm">{serverError}</span>
                </div>
              )}

              {/* Actions */}
              <div className="pt-2">
                <button 
                  className={`w-full bg-primary-container text-on-primary font-headline-sm text-headline-sm py-3.5 rounded-lg hover:bg-primary transition-colors flex items-center justify-center space-x-2 shadow-sm ${isSubmitting ? 'opacity-80 cursor-not-allowed' : ''}`} 
                  type="submit"
                  disabled={isSubmitting}
                >
                  {isSubmitting ? (
                    <>
                      <span className="material-symbols-outlined animate-spin">progress_activity</span>
                      <span>Processing...</span>
                    </>
                  ) : (
                    <>
                      <span>Create Account</span>
                      <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>arrow_right_alt</span>
                    </>
                  )}
                </button>
                <p className="mt-6 text-center font-body-sm text-body-sm text-on-surface-variant">
                  By registering, you agree to FitGuard's <Link to="/terms" className="text-primary hover:underline">Terms of Service</Link> and <Link to="/privacy" className="text-primary hover:underline">Privacy Policy</Link>.
                </p>
                <div className="mt-8 border-t border-outline-variant pt-6 text-center">
                  <p className="font-body-md text-body-md text-on-surface-variant">
                    Already have an account? <Link to="/login" className="text-primary font-medium hover:underline">Log in to Dashboard</Link>
                  </p>
                </div>
              </div>
            </form>
          </div>

          {/* Success State View */}
          {success && (
            <div className="absolute inset-0 bg-surface flex flex-col items-center justify-center text-center z-20 py-12 animate-in fade-in duration-500">
              <div className="w-24 h-24 bg-surface-container-low rounded-full flex items-center justify-center mb-8 mx-auto relative">
                <div className="absolute inset-0 rounded-full border-4 border-primary-container opacity-20 animate-ping"></div>
                <span className="material-symbols-outlined text-6xl text-primary-container" style={{ fontVariationSettings: "'FILL' 1" }}>check_circle</span>
              </div>
              <h2 className="font-display-md text-display-md text-on-surface mb-4">Account Verified!</h2>
              <p className="font-body-lg text-body-lg text-on-surface-variant mb-10 max-w-[320px] mx-auto">
                Your clinical profile has been successfully initialized. We are ready to begin telemetry analysis.
              </p>
              <button 
                className="bg-surface-container-highest text-on-surface font-label-md text-label-md py-3 px-8 rounded-lg hover:bg-surface-dim transition-colors border border-outline-variant inline-flex items-center space-x-2 shadow-sm" 
                onClick={() => navigate('/login')}
              >
                <span>Initialize Dashboard</span>
                <span className="material-symbols-outlined text-sm">rocket_launch</span>
              </button>
            </div>
          )}

        </div>
      </div>
    </div>
  );
}
