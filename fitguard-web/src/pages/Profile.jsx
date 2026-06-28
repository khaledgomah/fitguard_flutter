import { useEffect } from 'react';
import { Link } from 'react-router-dom';
import { useProfileStore } from '../store/profileStore';

export default function Profile() {
  const { profile, fetchProfile, loading } = useProfileStore();

  useEffect(() => {
    fetchProfile();
  } // eslint-disable-next-line react-hooks/exhaustive-deps
  , []);

  if (loading && !profile) {
    return <div className="p-8 text-center text-on-surface-variant">Loading profile...</div>;
  }

  return (
    <div className="max-w-container-max mx-auto space-y-6">
      {/* Athlete Summary Banner */}
      <div className="bg-surface-container-lowest border border-outline-variant rounded-xl p-6 flex flex-col md:flex-row items-start md:items-center justify-between gap-6 relative overflow-hidden">
        {/* Decorative ambient gradient */}
        <div className="absolute top-0 right-0 w-64 h-64 bg-primary-container opacity-5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/4 pointer-events-none"></div>
        <div className="flex items-center gap-6 z-10 relative">
          <div className="relative">
            <img 
              alt={profile?.name || 'Athlete'} 
              className="w-24 h-24 rounded-xl object-cover border border-outline-variant shadow-sm" 
              src={profile?.avatarUrl || "https://lh3.googleusercontent.com/aida-public/AB6AXuAApMoqc_iI7gQMJ5N_Tm8J1qnW-zsgTSnSA4ZUFgXfqtLovQqKmyoQi8Vat4rQXz5DR0cJK6Hi98S1S18y2RIICu80gwpQrC3e5tb8yGaBGLmDy7ksLl26QtiY7PhlulxwJ8YCCRR1HLNUL35uS_LtANfmmU7PCG5rUm0qCwjX5UMvQhB2i08OPDaK10U5G6l0eNTmtnRZD0TKC4CKY09ND0-MazgWDha3_Spn1hFuUH74EfngyyiDgJWwx1vA0LosuatK60TPoec"}
            />
            <div className="absolute -bottom-2 -right-2 bg-primary-container text-on-primary-container rounded-lg px-2 py-0.5 text-[10px] font-label-md uppercase border border-surface-container-lowest">Active</div>
          </div>
          <div>
            <h2 className="font-headline-lg text-headline-lg text-on-surface tracking-tight">{profile?.name || 'Unknown Athlete'}</h2>
            <p className="font-body-lg text-body-lg text-on-surface-variant">{profile?.sport || 'Professional Athlete'}</p>
            <div className="flex items-center gap-4 mt-2">
              <span className="inline-flex items-center gap-1 font-label-md text-label-md text-on-surface-variant bg-surface-container px-2 py-1 rounded">
                <span className="material-symbols-outlined text-[14px]">badge</span> ID: {profile?.id || 'FGP-0000'}
              </span>
            </div>
          </div>
        </div>
        <div className="flex items-center gap-3 z-10">
          <Link to="/profile/edit" className="bg-primary text-on-primary px-4 py-2 rounded-lg font-label-md text-label-md hover:opacity-90 transition-opacity flex items-center gap-2 shadow-sm">
            <span className="material-symbols-outlined text-[18px]">edit</span>
            Edit Profile
          </Link>
        </div>
      </div>

      {/* Bento Grid Layout */}
      <div className="grid grid-cols-12 gap-6">
        
        {/* Vitals / Physical Metrics (Col Span 4) */}
        <div className="col-span-12 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-5 flex flex-col justify-between">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
              <span className="material-symbols-outlined text-primary">straighten</span>
              Physical Metrics
            </h3>
          </div>
          <div className="grid grid-cols-2 gap-4">
            <div className="bg-surface-container-low p-3 rounded-lg border border-surface-dim">
              <p className="font-label-md text-label-md text-on-surface-variant uppercase mb-1">Age</p>
              <p className="font-display-md text-display-md text-on-surface font-black">{profile?.age || '--'}<span className="text-body-md font-normal text-on-surface-variant ml-1">yrs</span></p>
            </div>
            <div className="bg-surface-container-low p-3 rounded-lg border border-surface-dim">
              <p className="font-label-md text-label-md text-on-surface-variant uppercase mb-1">Height</p>
              <p className="font-display-md text-display-md text-on-surface font-black">{profile?.height || '--'}<span className="text-body-md font-normal text-on-surface-variant ml-1">cm</span></p>
            </div>
            <div className="col-span-2 bg-surface-container-low p-3 rounded-lg border border-surface-dim flex items-end justify-between">
              <div>
                <p className="font-label-md text-label-md text-on-surface-variant uppercase mb-1">Current Weight</p>
                <p className="font-display-md text-display-md text-on-surface font-black">{profile?.weight || '--'}<span className="text-body-md font-normal text-on-surface-variant ml-1">kg</span></p>
              </div>
            </div>
          </div>
        </div>

        {/* Quick Stats & Status (Col Span 4) */}
        <div className="col-span-12 md:col-span-6 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
              <span className="material-symbols-outlined text-secondary">vital_signs</span>
              Readiness Status
            </h3>
          </div>
          <div className="space-y-4">
            {/* Readiness Score */}
            <div className="flex items-center justify-between p-3 rounded-lg bg-surface-container-low border border-surface-dim">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded bg-surface-container-highest flex items-center justify-center">
                  <span className="material-symbols-outlined text-primary">battery_charging_full</span>
                </div>
                <div>
                  <p className="font-label-md text-label-md text-on-surface-variant uppercase">Neuromuscular</p>
                  <p className="font-headline-sm text-headline-sm text-on-surface">Optimized</p>
                </div>
              </div>
              <div className="text-right">
                <p className="font-display-md text-display-md text-primary font-black">94<span className="text-headline-sm text-on-surface-variant">%</span></p>
              </div>
            </div>
            {/* Injury Status */}
            <div className="flex items-center justify-between p-3 rounded-lg border border-outline-variant relative overflow-hidden">
              <div className="absolute left-0 top-0 bottom-0 w-1 bg-primary"></div>
              <div>
                <p className="font-label-md text-label-md text-on-surface-variant uppercase mb-0.5">Days Since Last Injury</p>
                <p className="font-headline-md text-headline-md text-on-surface font-bold">142 Days</p>
              </div>
              <span className="material-symbols-outlined text-outline-variant text-[32px] opacity-20">healing</span>
            </div>
          </div>
        </div>

        {/* Active Challenges / Focus (Col Span 4) */}
        <div className="col-span-12 md:col-span-6 lg:col-span-4 bg-surface-container-lowest border border-outline-variant rounded-xl p-5">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
              <span className="material-symbols-outlined text-tertiary">target</span>
              Active Focus Areas
            </h3>
          </div>
          <ul className="space-y-3">
            <li className="flex items-start gap-3 p-3 bg-surface rounded-lg border border-outline-variant">
              <span className="material-symbols-outlined text-tertiary mt-0.5">warning</span>
              <div>
                <p className="font-label-md text-label-md text-on-surface">Hamstring Load Management</p>
                <p className="font-body-sm text-body-sm text-on-surface-variant mt-0.5">Cap high-speed distance to &lt; 400m per session this week.</p>
              </div>
            </li>
            <li className="flex items-start gap-3 p-3 bg-surface rounded-lg border border-outline-variant">
              <span className="material-symbols-outlined text-secondary mt-0.5">psychology</span>
              <div>
                <p className="font-label-md text-label-md text-on-surface">Sleep Quality Deficit</p>
                <p className="font-body-sm text-body-sm text-on-surface-variant mt-0.5">REM stages down 12% over 72h. Implement protocol B.</p>
              </div>
            </li>
          </ul>
        </div>

        {/* Recent Activity Feed (Col Span 12) */}
        <div className="col-span-12 bg-surface-container-lowest border border-outline-variant rounded-xl p-5">
          <div className="flex items-center justify-between mb-6 border-b border-outline-variant pb-4">
            <h3 className="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
              <span className="material-symbols-outlined text-on-surface-variant">history</span>
              Recent Activity
            </h3>
          </div>
          <div className="space-y-0 relative before:absolute before:inset-0 before:ml-5 before:-translate-x-px md:before:mx-auto md:before:translate-x-0 before:h-full before:w-0.5 before:bg-gradient-to-b before:from-outline-variant before:via-outline-variant before:to-transparent">
            {/* Activity Item 1 */}
            <div className="relative flex items-center justify-between md:justify-normal md:odd:flex-row-reverse group pb-6">
              <div className="flex items-center justify-center w-10 h-10 rounded-full border-2 border-surface-container-lowest bg-primary text-on-primary shrink-0 md:order-1 md:group-odd:-translate-x-1/2 md:group-even:translate-x-1/2 shadow-sm z-10 absolute left-0 md:left-1/2 -ml-5 md:ml-0">
                <span className="material-symbols-outlined text-[18px]">directions_run</span>
              </div>
              <div className="w-[calc(100%-3rem)] md:w-[calc(50%-2.5rem)] pl-8 md:pl-0 bg-surface-container-lowest text-right md:group-odd:text-left">
                <div className="p-4 rounded-xl border border-outline-variant bg-surface-container-low/50 group-hover:border-primary/50 transition-colors text-left">
                  <div className="flex justify-between items-start mb-1">
                    <p className="font-label-md text-label-md text-primary uppercase">Today • 08:30 AM</p>
                    <span className="px-2 py-0.5 rounded text-[10px] font-label-md bg-surface-container border border-outline-variant text-on-surface-variant">Field</span>
                  </div>
                  <h4 className="font-headline-sm text-headline-sm text-on-surface mb-1">Speed & Agility Session</h4>
                  <p className="font-body-sm text-body-sm text-on-surface-variant">Duration: 45m. Max Velocity: 21.4 mph. No reported discomfort.</p>
                </div>
              </div>
            </div>
            {/* Activity Item 2 */}
            <div className="relative flex items-center justify-between md:justify-normal md:odd:flex-row-reverse group pb-6">
              <div className="flex items-center justify-center w-10 h-10 rounded-full border-2 border-surface-container-lowest bg-surface-container-highest text-on-surface-variant shrink-0 md:order-1 md:group-odd:-translate-x-1/2 md:group-even:translate-x-1/2 shadow-sm z-10 absolute left-0 md:left-1/2 -ml-5 md:ml-0">
                <span className="material-symbols-outlined text-[18px]">spa</span>
              </div>
              <div className="w-[calc(100%-3rem)] md:w-[calc(50%-2.5rem)] pl-8 md:pl-0 bg-surface-container-lowest text-right md:group-odd:text-left">
                <div className="p-4 rounded-xl border border-outline-variant bg-surface group-hover:border-outline transition-colors text-left">
                  <div className="flex justify-between items-start mb-1">
                    <p className="font-label-md text-label-md text-on-surface-variant uppercase">Yesterday • 04:15 PM</p>
                    <span className="px-2 py-0.5 rounded text-[10px] font-label-md bg-surface-container border border-outline-variant text-on-surface-variant">Clinic</span>
                  </div>
                  <h4 className="font-headline-sm text-headline-sm text-on-surface mb-1">Recovery Protocol</h4>
                  <p className="font-body-sm text-body-sm text-on-surface-variant">Cryotherapy (3m) followed by normative compression (20m).</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
