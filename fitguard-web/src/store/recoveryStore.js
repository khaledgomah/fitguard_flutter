import { create } from 'zustand';
import { recoveryService } from '../services/recoveryService';

export const useRecoveryStore = create((set) => ({
  protocols: [],
  activeProtocol: null,
  progress: null,
  loading: false,
  error: null,

  fetchProtocols: async () => {
    set({ loading: true, error: null });
    try {
      const data = await recoveryService.getRecoveryProtocols();
      set({ protocols: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch recovery protocols', loading: false });
    }
  },

  fetchActiveProtocol: async () => {
    set({ loading: true, error: null });
    try {
      const data = await recoveryService.getActiveRecovery();
      set({ activeProtocol: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch active protocol', loading: false });
    }
  },

  fetchProtocolById: async (id) => {
    set({ loading: true, error: null });
    try {
      const data = await recoveryService.getRecoveryById(id);
      return data;
    } catch (err) {
      set({ error: err.message || 'Failed to fetch protocol', loading: false });
      throw err;
    }
  },

  generateProtocol: async (params) => {
    set({ loading: true, error: null });
    try {
      const newProtocol = await recoveryService.generateRecovery(params);
      set((state) => ({ 
        protocols: [newProtocol, ...state.protocols],
        activeProtocol: newProtocol,
        loading: false 
      }));
      return newProtocol;
    } catch (err) {
      set({ error: err.message || 'Failed to generate protocol', loading: false });
      throw err;
    }
  },

  completePhase: async (id, phaseNumber) => {
    set({ loading: true, error: null });
    try {
      const updatedProtocol = await recoveryService.completeRecoveryPhase(id, phaseNumber);
      set((state) => ({
        activeProtocol: state.activeProtocol?.id === id ? updatedProtocol : state.activeProtocol,
        protocols: state.protocols.map(p => p.id === id ? updatedProtocol : p),
        loading: false
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to complete phase', loading: false });
      throw err;
    }
  },

  toggleExercise: async (id, phaseNumber, exerciseId) => {
    try {
      const updatedProtocol = await recoveryService.toggleRecoveryExercise(id, phaseNumber, exerciseId);
      set((state) => ({
        activeProtocol: state.activeProtocol?.id === id ? updatedProtocol : state.activeProtocol,
        protocols: state.protocols.map(p => p.id === id ? updatedProtocol : p)
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to toggle exercise' });
      throw err;
    }
  }
}));
