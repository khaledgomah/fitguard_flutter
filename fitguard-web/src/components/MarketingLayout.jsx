
import { Link, NavLink } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

export default function MarketingLayout({ children }) {
  const { isAuthenticated } = useAuthStore();
  return (
    <div className="min-h-screen flex flex-col font-body-md bg-background text-on-background antialiased relative">
      {/* Background Pattern */}
      <style>{`
        .bg-pattern {
            background-image: radial-gradient(theme('colors.outline-variant') 1px, transparent 1px);
            background-size: 24px 24px;
        }
      `}</style>
      
      {/* TopNavBar (Marketing) */}
      <nav className="w-full h-[64px] sticky top-0 bg-surface dark:bg-on-background border-b border-outline-variant dark:border-outline z-50">
        <div className="flex justify-between items-center px-margin-desktop max-w-container-max mx-auto h-full">
          <div className="text-headline-md font-headline-md font-bold text-primary dark:text-primary-fixed-dim">
            FitGuard
          </div>
          <div className="hidden md:flex space-x-8">
            <NavLink to="/" className={({isActive}) => isActive ? "text-primary dark:text-primary-fixed-dim font-bold border-b-2 border-primary font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200 opacity-80" : "text-on-surface-variant dark:text-surface-variant font-medium font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200"}>Home</NavLink>
            <NavLink to="/about" className={({isActive}) => isActive ? "text-primary dark:text-primary-fixed-dim font-bold border-b-2 border-primary font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200 opacity-80" : "text-on-surface-variant dark:text-surface-variant font-medium font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200"}>About</NavLink>
            <NavLink to="/faq" className={({isActive}) => isActive ? "text-primary dark:text-primary-fixed-dim font-bold border-b-2 border-primary font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200 opacity-80" : "text-on-surface-variant dark:text-surface-variant font-medium font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200"}>FAQ</NavLink>
            <NavLink to="/contact" className={({isActive}) => isActive ? "text-primary dark:text-primary-fixed-dim font-bold border-b-2 border-primary font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200 opacity-80" : "text-on-surface-variant dark:text-surface-variant font-medium font-label-md text-label-md hover:text-primary dark:hover:text-primary-fixed-dim transition-colors duration-200"}>Contact</NavLink>
          </div>
          <div className="flex items-center space-x-4">
            {isAuthenticated ? (
              <Link to="/dashboard" className="bg-primary-container text-on-primary-container px-6 py-2 rounded-lg font-label-md text-label-md hover:opacity-90 transition-opacity">Dashboard</Link>
            ) : (
              <>
                <Link to="/login" className="text-on-surface font-label-md text-label-md hover:text-primary transition-colors">Login</Link>
                <Link to="/register" className="bg-primary-container text-on-primary-container px-6 py-2 rounded-lg font-label-md text-label-md hover:opacity-90 transition-opacity">Sign Up</Link>
              </>
            )}
          </div>
        </div>
      </nav>

      <main className="flex-grow">
        {children}
      </main>

      {/* Footer */}
      <footer className="bg-surface-container-lowest dark:bg-on-background w-full py-16 border-t border-outline-variant dark:border-outline mt-auto">
        <div className="flex flex-col md:flex-row justify-between items-center px-margin-desktop max-w-container-max mx-auto">
          <div className="font-headline-sm text-primary dark:text-primary-fixed-dim mb-6 md:mb-0">
            FitGuard
          </div>
          <div className="flex flex-wrap justify-center gap-6 mb-6 md:mb-0">
          </div>
          <div className="font-body-sm text-body-sm text-on-surface-variant dark:text-outline-variant">
            © FitGuard AI. Clinical Precision in Motion.
          </div>
        </div>
      </footer>
    </div>
  );
}
