import { Link } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';
import { useNotificationStore } from '../store/notificationStore';

export default function AppHeader() {
  const user = useAuthStore((state) => state.user);
  const unreadCount = useNotificationStore((state) => state.unreadCount);

  return (
    <header className="h-[64px] sticky top-0 bg-surface border-b border-outline-variant flex justify-between items-center px-4 md:px-8 z-10">
      {/* Mobile Menu Button */ }
      <div className="md:hidden flex items-center">
        <button className="text-on-surface-variant p-2 mr-2 rounded-lg hover:bg-surface-container-high transition-colors">
          <span className="material-symbols-outlined">menu</span>
        </button>
      </div>



      <div className="flex items-center space-x-2 ml-auto">
        <Link to="/notifications" className="relative text-on-surface-variant hover:bg-surface-container-high rounded-full p-2 transition-transform duration-200 hover:scale-105 active:scale-95 flex items-center justify-center">
          <span className="material-symbols-outlined text-primary">notifications</span>
          {unreadCount > 0 && (
            <span className="absolute top-1 right-1 w-2.5 h-2.5 bg-error rounded-full"></span>
          )}
        </Link>
        <Link to="/profile" className="text-on-surface-variant hover:bg-surface-container-high rounded-full p-2 transition-transform duration-200 hover:scale-105 active:scale-95 flex items-center justify-center overflow-hidden">
          {user?.avatarUrl ? (
            <img 
              src={user.avatarUrl} 
              alt="Profile" 
              className="w-8 h-8 rounded-full object-cover"
            />
          ) : (
            <img 
              src="https://lh3.googleusercontent.com/aida-public/AB6AXuCF0Uu2YajOO33g6fjIKQjK8obJDier1d243ay8PfxRzQVXjlVXPXKKID7AGPKxSDLCLTrOu9e17Bg1RQtuu4dzvkHjG0St2Pm-MOakCHKpfEXoxatwOcGOt7q3Lt6gqsxC9jV6Vuc9FaYPtJWs4n4E9VVXBL8UFYDm2W29-iSWDqXQUbVArOf1FMvffryFX4CQdktkzZRo6G3fBNO0-kokClbN7mTyCUT2Qdsipyg6ezC18zAiIBxvCOieTNQhIrMLLfvUC-3duJs" 
              alt="Default Profile" 
              className="w-8 h-8 rounded-full object-cover"
            />
          )}
        </Link>
      </div>
    </header>
  );
}
