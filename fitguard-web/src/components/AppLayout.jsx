
import { Link } from 'react-router-dom';
import { useNotificationStore } from '../store/notificationStore';
import { useProfileStore } from '../store/profileStore';
import Sidebar from './Sidebar';

export default function AppLayout({ children }) {
  const { unreadCount } = useNotificationStore();
  const { profile } = useProfileStore();  return (
    <div className="flex bg-surface min-h-screen font-body-md text-body-md text-on-surface">
      {/* SideNavBar */}
      <Sidebar />

      {/* Main Content Area Wrapper */}
      <div className="ml-[260px] w-[calc(100%-260px)] flex flex-col min-h-screen">
        {/* TopNavBar */}
        <header className="h-[64px] sticky top-0 bg-surface border-b border-outline-variant flex justify-between items-center px-8 z-10">

          <div className="flex items-center space-x-2 ml-auto">
            <Link to="/notifications" className="text-on-surface-variant hover:bg-surface-container-high rounded-full p-2 transition-transform duration-200 hover:scale-105 active:scale-95 flex items-center justify-center relative">
              <span className="material-symbols-outlined text-primary">notifications</span>
              {unreadCount > 0 && (
                <span className="absolute top-1 right-2 w-2 h-2 bg-error rounded-full border border-surface-container-lowest"></span>
              )}
            </Link>
            <Link to="/profile" className="text-on-surface-variant hover:bg-surface-container-high rounded-full p-2 transition-transform duration-200 hover:scale-105 active:scale-95 flex items-center justify-center overflow-hidden">
              <img alt="Athlete Profile Image" className="w-8 h-8 rounded-full object-cover" src={profile?.avatarUrl || "https://ui-avatars.com/api/?name=" + (profile?.name || "Athlete") + "&background=random"} />
            </Link>
          </div>
        </header>

        {/* Canvas */}
        <main className="flex-grow p-8 bg-surface">
          {children}
        </main>
      </div>
    </div>
  );
}
