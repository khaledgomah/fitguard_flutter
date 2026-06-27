import { Link } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

export default function Home() {
  const { isAuthenticated } = useAuthStore();
  return (
    <>
      {/* Hero Section */}
      <section className="relative pt-32 pb-24 px-margin-mobile md:px-margin-desktop overflow-hidden">
        <div className="absolute inset-0 bg-pattern opacity-50 z-0"></div>
        <div className="max-w-container-max mx-auto grid grid-cols-1 lg:grid-cols-12 gap-gutter relative z-10">
          <div className="lg:col-span-6 flex flex-col justify-center pr-8">
            <div className="inline-flex items-center space-x-2 bg-secondary-container bg-opacity-10 text-on-secondary-container px-3 py-1 rounded-full mb-6 w-fit">
              <span className="material-symbols-outlined text-[16px]" style={{ fontVariationSettings: "'FILL' 1" }}>auto_awesome</span>
              <span className="font-label-md text-label-md uppercase tracking-wider">AI-Powered Analytics</span>
            </div>
            <h1 className="font-display-lg text-display-lg text-on-surface mb-6">
              AI-Powered Athlete <br/><span className="text-primary">Injury Prevention</span> <br/>& Recovery
            </h1>
            <p className="font-body-lg text-body-lg text-on-surface-variant mb-10 max-w-lg">
              Clinical precision meets elite performance. Track biometrics, predict injury risk, and execute AI-generated rehab plans tailored to your physiology.
            </p>
            <div className="flex flex-col sm:flex-row space-y-4 sm:space-y-0 sm:space-x-4">
              {isAuthenticated ? (
                <Link to="/dashboard" className="bg-primary-container text-on-primary-container px-8 py-4 rounded-xl font-label-md text-label-md hover:shadow-md transition-all text-center">
                  Go to Dashboard
                </Link>
              ) : (
                <Link to="/register" className="bg-primary-container text-on-primary-container px-8 py-4 rounded-xl font-label-md text-label-md hover:shadow-md transition-all text-center">
                  Start Your Recovery Journey
                </Link>
              )}
            </div>
          </div>
          
          <div className="lg:col-span-6 relative mt-16 lg:mt-0">
            {/* High-performance imagery */}
            <div className="rounded-2xl overflow-hidden aspect-[4/3] bg-surface-container relative shadow-2xl">
              <img src="/hero-bg.png" alt="Athlete training with biometric tracking" className="absolute inset-0 w-full h-full object-cover" />
              {/* Subtle color overlay */}
              <div className="absolute inset-0 opacity-20 bg-[radial-gradient(ellipse_at_center,_var(--tw-gradient-stops))] from-primary via-transparent to-surface-container mix-blend-overlay"></div>
              {/* Floating Data Card */}
              <div className="absolute bottom-6 left-6 bg-surface-container-lowest border border-outline-variant p-4 rounded-xl shadow-lg w-64 backdrop-blur-md bg-opacity-90">
                <div className="flex justify-between items-center mb-2">
                  <span className="font-label-md text-label-md text-on-surface-variant">Strain Index</span>
                  <span className="material-symbols-outlined text-primary text-[18px]">trending_up</span>
                </div>
                <div className="flex items-baseline space-x-2">
                  <span className="font-headline-lg text-headline-lg text-on-surface">14.2</span>
                  <span className="font-mono-data text-mono-data text-primary">Optimal</span>
                </div>
                <div className="w-full bg-surface-container-high h-1 mt-3 rounded-full overflow-hidden">
                  <div className="bg-primary w-[70%] h-full rounded-full"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Bento Grid */}
      <section className="py-24 bg-surface-container-lowest px-margin-mobile md:px-margin-desktop">
        <div className="max-w-container-max mx-auto">
          <div className="text-center mb-16">
            <h2 className="font-display-md text-display-md text-on-surface mb-4">Precision Tools for Elite Performance</h2>
            <p className="font-body-lg text-body-lg text-on-surface-variant max-w-2xl mx-auto">Everything you need to stay in the game and recover faster.</p>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-12 gap-gutter">
            
            {/* Feature 1: Injury Tracking */}
            <div className="md:col-span-8 bg-surface border border-outline-variant rounded-2xl p-8 hover:border-outline transition-colors group">
              <div className="flex items-center space-x-3 mb-6">
                <div className="bg-error-container text-on-error-container p-3 rounded-lg">
                  <span className="material-symbols-outlined">health_and_safety</span>
                </div>
                <h3 className="font-headline-md text-headline-md text-on-surface">Track Injuries</h3>
              </div>
              <p className="font-body-md text-body-md text-on-surface-variant mb-8 max-w-md">Log pain points, monitor inflammation, and track the full lifecycle of an injury with clinical precision.</p>
              
              {/* Visual Preview */}
              <div className="bg-surface-container-low rounded-xl p-6 border border-outline-variant h-48 relative overflow-hidden flex items-end justify-center">
                <div className="w-full flex items-end justify-between px-4 space-x-2">
                  <div className="w-1/6 bg-error bg-opacity-20 rounded-t-md h-12"></div>
                  <div className="w-1/6 bg-error bg-opacity-40 rounded-t-md h-24"></div>
                  <div className="w-1/6 bg-error bg-opacity-80 rounded-t-md h-32"></div>
                  <div className="w-1/6 bg-primary bg-opacity-40 rounded-t-md h-20"></div>
                  <div className="w-1/6 bg-primary bg-opacity-60 rounded-t-md h-16"></div>
                  <div className="w-1/6 bg-primary bg-opacity-80 rounded-t-md h-8"></div>
                </div>
              </div>
            </div>

            {/* Feature 2: AI Rehab Plans */}
            <div className="md:col-span-4 bg-surface border border-outline-variant rounded-2xl p-8 hover:border-outline transition-colors flex flex-col justify-between">
              <div>
                <div className="flex items-center space-x-3 mb-6">
                  <div className="bg-secondary-container bg-opacity-20 text-on-secondary-container p-3 rounded-lg">
                    <span className="material-symbols-outlined" style={{ fontVariationSettings: "'FILL' 1" }}>psychology</span>
                  </div>
                  <h3 className="font-headline-md text-headline-md text-on-surface">AI Rehab Plans</h3>
                </div>
                <p className="font-body-md text-body-md text-on-surface-variant mb-6">Dynamic, evolving recovery protocols generated from your biometric data and injury profile.</p>
              </div>
              <div className="bg-secondary-container bg-opacity-5 rounded-xl p-4 border border-secondary-container border-opacity-20">
                <div className="flex items-center space-x-3 mb-2">
                  <span className="material-symbols-outlined text-secondary text-[20px]">check_circle</span>
                  <span className="font-label-md text-label-md text-on-surface">Mobility Protocol Generated</span>
                </div>
                <div className="w-full bg-surface-container-high h-1 rounded-full overflow-hidden">
                  <div className="bg-secondary w-full h-full rounded-full"></div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </section>
    </>
  );
}
