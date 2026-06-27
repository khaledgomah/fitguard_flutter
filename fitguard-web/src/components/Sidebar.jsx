
import { Link, useLocation } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

export default function Sidebar() {
  const location = useLocation();
  const logout = useAuthStore((state) => state.logout);

  const isActive = (path) => location.pathname === path || location.pathname.startsWith(path + '/');

  const getLinkClasses = (path) => {
    return isActive(path)
      ? "flex items-center space-x-3 px-4 py-3 bg-primary-container text-on-primary-container rounded-xl transition-all duration-100 scale-95 origin-left"
      : "flex items-center space-x-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-highest transition-colors rounded-xl";
  };

  const getIconFill = (path) => isActive(path) ? { fontVariationSettings: "'FILL' 1" } : {};

  return (
    <nav className="w-[260px] h-full fixed left-0 top-0 bg-surface-container flex flex-col p-4 space-y-2 z-20">
      <div className="mb-8 px-4 flex items-center space-x-3 mt-4">
        <span className="material-symbols-outlined text-primary text-3xl" style={{ fontVariationSettings: "'FILL' 1" }}>health_and_safety</span>
        <div className="flex flex-col">
          <span className="font-headline-sm text-headline-sm font-black text-primary">FitGuard</span>
          <span className="font-label-md text-label-md text-on-surface-variant">Elite Performance</span>
        </div>
      </div>
      <div className="flex-grow space-y-1">
        <Link className={getLinkClasses('/dashboard')} to="/dashboard">
          <span className="material-symbols-outlined" style={getIconFill('/dashboard')}>dashboard</span>
          <span className="font-label-md text-label-md">Dashboard</span>
        </Link>
        <Link className={getLinkClasses('/injuries')} to="/injuries">
          <span className="material-symbols-outlined" style={getIconFill('/injuries')}>monitor_heart</span>
          <span className="font-label-md text-label-md">Biometrics</span>
        </Link>
        <Link className={getLinkClasses('/recovery')} to="/recovery">
          <span className="material-symbols-outlined" style={getIconFill('/recovery')}>rebase_edit</span>
          <span className="font-label-md text-label-md">Recovery Plan</span>
        </Link>
        <Link className={getLinkClasses('/challenges')} to="/challenges">
          <span className="material-symbols-outlined" style={getIconFill('/challenges')}>analytics</span>
          <span className="font-label-md text-label-md">Challenges</span>
        </Link>
        <Link className={getLinkClasses('/settings')} to="/settings">
          <span className="material-symbols-outlined" style={getIconFill('/settings')}>settings</span>
          <span className="font-label-md text-label-md">Settings</span>
        </Link>
      </div>
      <Link to="/challenges/generate" className="w-full mt-4 py-3 px-4 bg-primary text-on-primary font-label-md text-label-md rounded-lg hover:bg-surface-tint transition-colors shadow-sm flex items-center justify-center space-x-2">
        <span className="material-symbols-outlined text-sm" style={{ fontVariationSettings: "'FILL' 1" }}>add</span>
        <span>New Analysis</span>
      </Link>
      <div className="mt-auto pt-4 border-t border-surface-container-low space-y-1">

        <button 
          onClick={logout}
          className="w-full flex items-center space-x-3 px-4 py-3 text-on-surface-variant hover:bg-surface-container-highest transition-colors rounded-xl text-left"
        >
          <span className="material-symbols-outlined">logout</span>
          <span className="font-label-md text-label-md">Logout</span>
        </button>
      </div>
    </nav>
  );
}
