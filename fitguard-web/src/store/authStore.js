import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { authService } from '../services/authService';

export const useAuthStore = create(
  persist(
    (set) => ({
      user: null,
      token: null,
      refreshToken: null,
      isAuthenticated: false,
      _hasHydrated: false,
      
      setHasHydrated: (state) => set({ _hasHydrated: state }),

      login: async (credentials) => {
        try {
          const data = await authService.login(credentials);
          set({ 
            user: data.user, 
            token: data.access_token, 
            isAuthenticated: true 
          });
          return true;
        } catch (error) {
          console.error('Login error:', error);
          throw error;
        }
      },
      
      logout: async () => {
        try {
          await authService.logout();
        } finally {
          set({ user: null, token: null, refreshToken: null, isAuthenticated: false });
        }
      },
      
      refreshSession: async () => {
        try {
          const data = await authService.refreshToken();
          set({ token: data.access_token, isAuthenticated: true });
        } catch (error) {
          console.error('Session refresh failed', error);
          set({ user: null, token: null, isAuthenticated: false });
        }
      },

      updatePassword: async (passwords) => {
        set({ loading: true, error: null });
        try {
          await authService.updatePassword(passwords);
          set({ loading: false });
        } catch (err) {
          set({ error: err.response?.data?.message || err.message || 'Failed to update password', loading: false });
          throw err;
        }
      }
    }),
    {
      name: 'auth-storage',
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({ 
        user: state.user,
        token: state.token,
        refreshToken: state.refreshToken,
        isAuthenticated: state.isAuthenticated
      }),
      onRehydrateStorage: () => (state) => {
        if (state) {
          state.setHasHydrated(true);
        }
      }
    }
  )
);
