import { Navigate, useLocation } from 'react-router-dom';
import { useAuthStore } from '../store/authStore';

export default function AuthGuard({ children }) {
  const { isAuthenticated, _hasHydrated } = useAuthStore();
  const location = useLocation();

  if (!_hasHydrated) {
    // Prevent flashing logged-out state during hydration
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-surface">
        <div className="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />;
  }

  return children;
}
