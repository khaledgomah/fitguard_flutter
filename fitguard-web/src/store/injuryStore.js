import { create } from 'zustand';
import { injuryService } from '../services/injuryService';

export const useInjuryStore = create((set) => ({
  injuries: [],
  selectedInjury: null,
  injuryPatterns: null,
  loading: false,
  error: null,

  fetchInjuries: async () => {
    set({ loading: true, error: null });
    try {
      const data = await injuryService.getInjuries();
      set({ injuries: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch injuries', loading: false });
    }
  },

  fetchInjury: async (id) => {
    set({ loading: true, error: null });
    try {
      const data = await injuryService.getInjuryById(id);
      set({ selectedInjury: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch injury details', loading: false });
    }
  },

  createInjury: async (injuryData) => {
    set({ loading: true, error: null });
    try {
      const newInjury = await injuryService.createInjury(injuryData);
      set((state) => ({ 
        injuries: [...state.injuries, newInjury],
        loading: false 
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to create injury', loading: false });
      throw err;
    }
  },

  updateInjury: async (id, updateData) => {
    set({ loading: true, error: null });
    try {
      const updatedInjury = await injuryService.updateInjury(id, updateData);
      set((state) => ({
        injuries: state.injuries.map(inj => inj.id === id ? updatedInjury : inj),
        selectedInjury: state.selectedInjury?.id === id ? updatedInjury : state.selectedInjury,
        loading: false
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to update injury', loading: false });
      throw err;
    }
  },

  deleteInjury: async (id) => {
    set({ loading: true, error: null });
    try {
      await injuryService.deleteInjury(id);
      set((state) => ({
        injuries: state.injuries.filter(inj => inj.id !== id),
        selectedInjury: state.selectedInjury?.id === id ? null : state.selectedInjury,
        loading: false
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to delete injury', loading: false });
      throw err;
    }
  },

  fetchPatterns: async () => {
    set({ loading: true, error: null });
    try {
      const data = await injuryService.getInjuryPatterns();
      set({ injuryPatterns: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch injury patterns', loading: false });
    }
  }
}));
