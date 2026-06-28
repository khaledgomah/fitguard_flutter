import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { useNavigate, Link, useLocation } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

const loginSchema = z.object({
  email: z.string().email('Please enter a valid email address'),
  password: z.string().min(1, 'Password is required')
});

export default function Login() {
  const navigate = useNavigate();
  const location = useLocation();
  const login = useAuthStore((state) => state.login);
  const [serverError, setServerError] = useState('');

  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting }
  } = useForm({
    resolver: zodResolver(loginSchema)
  });

  const onSubmit = async (data) => {
    try {
      setServerError('');
      // Actual API call via Zustand store
      await login(data);
      
      const destination = location.state?.from?.pathname || '/dashboard';
      navigate(destination, { replace: true });
    } catch (err) {
      setServerError(err.response?.data?.message || 'An error occurred during login');
    }
  };

  return (
    <div className="bg-surface-container-lowest min-h-screen flex flex-col md:flex-row overflow-hidden font-body-md text-on-surface">
      {/* Left Side: Hero Image */}
      <div className="hidden md:block md:w-1/2 relative bg-surface-container-high h-screen">
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent z-10"></div>
        <img 
          alt="Athlete in recovery" 
          className="absolute inset-0 w-full h-full object-cover z-0" 
          src="https://lh3.googleusercontent.com/aida-public/AB6AXuDj0gUTl0IkJMcbPFQA_--U8xnToqkfm0hwPbSoso0jJZxCVpUejgH_BCzK2vQJPZQ_x5DRTM8-IBEn_56R-dcJCdTorZR0GKVLfC_q23Or0jA3kcKfvgelVDIbEiudHNQvHayS7wKC2SagFG_2szFOv18oepCs5zwBxFXwe1PsYkkMt86afbTGHeUnQLWcL2uX8tM6hRhqV7yCnOGvkJA2MbVJN3YOOFaeU_PtWLIi09bMLTOS8q1KNeXLNVuw_9gE7uCSrNOYR2Y"
        />
        <div className="absolute bottom-margin-desktop left-margin-desktop z-20 max-w-md">
          <h1 className="font-display-lg text-display-lg text-white mb-4">FitGuard</h1>
          <p className="font-body-lg text-body-lg text-white/90">
            Clinical Precision in Motion. Access your biometric recovery data and optimize performance.
          </p>
        </div>
      </div>

      {/* Right Side: Login Form */}
      <div className="w-full md:w-1/2 flex items-center justify-center p-margin-mobile md:p-margin-desktop h-screen overflow-y-auto">
        <div className="w-full max-w-[420px]">
          {/* Mobile Header */}
          <div className="md:hidden mb-12">
            <h1 className="font-headline-lg text-headline-lg text-primary text-center">FitGuard</h1>
          </div>

          <div className="mb-8">
            <h2 className="font-headline-md text-headline-md text-on-surface mb-2">Welcome Back</h2>
            <p className="font-body-md text-body-md text-on-surface-variant">
              Enter your credentials to access your dashboard.
            </p>
          </div>

          {/* Login Form */}
          <form className="space-y-6" onSubmit={handleSubmit(onSubmit)}>
            {/* Email Input */}
            <div className="space-y-2">
              <label className="font-label-md text-label-md text-on-surface-variant block uppercase" htmlFor="email">
                Email Address
              </label>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline" style={{ fontVariationSettings: "'FILL' 0" }}>
                  mail
                </span>
                <input 
                  className={`w-full pl-10 pr-4 py-3 bg-surface-container-lowest border ${errors.email ? 'border-error' : 'border-outline-variant'} rounded focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary font-body-md text-body-md text-on-surface placeholder-outline transition-colors`} 
                  id="email" 
                  placeholder="your@email.com" 
                  type="email"
                  {...register('email')}
                />
              </div>
              {errors.email && (
                <p className="text-error text-body-sm mt-1">{errors.email.message}</p>
              )}
            </div>

            {/* Password Input */}
            <div className="space-y-2">
              <div className="flex justify-between items-center">
                <label className="font-label-md text-label-md text-on-surface-variant block uppercase" htmlFor="password">
                  Password
                </label>
              </div>
              <div className="relative">
                <span className="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline" style={{ fontVariationSettings: "'FILL' 0" }}>
                  lock
                </span>
                <input 
                  className={`w-full pl-10 pr-4 py-3 bg-surface-container-lowest border ${errors.password ? 'border-error' : 'border-outline-variant'} rounded focus:outline-none focus:ring-1 focus:ring-primary focus:border-primary font-body-md text-body-md text-on-surface placeholder-outline transition-colors`} 
                  id="password" 
                  placeholder="••••••••" 
                  type="password"
                  {...register('password')}
                />
              </div>
              {errors.password && (
                <p className="text-error text-body-sm mt-1">{errors.password.message}</p>
              )}
            </div>

            {/* Server Error */}
            {serverError && (
              <div className="bg-error-container text-error p-3 rounded flex items-center gap-2">
                <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>error</span>
                <span className="font-body-sm text-body-sm">{serverError}</span>
              </div>
            )}

            {/* Submit Button */}
            <button 
              className={`w-full bg-primary-container text-on-primary-container hover:bg-primary hover:text-on-primary font-label-md text-label-md uppercase tracking-wider py-3 px-4 rounded transition-colors flex items-center justify-center gap-2 ${isSubmitting ? 'opacity-80 cursor-not-allowed' : ''}`} 
              type="submit"
              disabled={isSubmitting}
            >
              <span>{isSubmitting ? 'Logging in...' : 'Login'}</span>
              {isSubmitting && (
                <span className="material-symbols-outlined animate-spin" style={{ fontVariationSettings: "'FILL' 0" }}>
                  progress_activity
                </span>
              )}
            </button>

            {/* Registration Link */}
            <div className="text-center mt-6">
              <p className="font-body-sm text-body-sm text-on-surface-variant">
                Don't have an account? <Link to="/register" className="text-primary font-medium hover:underline">Register</Link>
              </p>
            </div>
          </form>


        </div>
      </div>
    </div>
  );
}
