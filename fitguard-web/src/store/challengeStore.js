import { create } from 'zustand';
import { challengeService } from '../services/challengeService';

export const useChallengeStore = create((set) => ({
  challenges: [],
  activeChallenge: null,
  progress: null,
  loading: false,
  error: null,

  fetchChallenges: async () => {
    set({ loading: true, error: null });
    try {
      const data = await challengeService.getChallenges();
      set({ challenges: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch challenges', loading: false });
    }
  },

  fetchActiveChallenge: async () => {
    set({ loading: true, error: null });
    try {
      const data = await challengeService.getActiveChallenge();
      set({ activeChallenge: data, loading: false });
    } catch (err) {
      set({ error: err.message || 'Failed to fetch active challenge', loading: false });
    }
  },

  fetchChallengeById: async (id) => {
    set({ loading: true, error: null });
    try {
      const data = await challengeService.getChallengeById(id);
      return data;
    } catch (err) {
      set({ error: err.message || 'Failed to fetch challenge', loading: false });
      throw err;
    }
  },

  generateChallenge: async (params) => {
    set({ loading: true, error: null });
    try {
      const newChallenge = await challengeService.generateChallenge(params);
      set((state) => ({ 
        challenges: [newChallenge, ...state.challenges],
        activeChallenge: newChallenge,
        loading: false 
      }));
      return newChallenge;
    } catch (err) {
      set({ error: err.message || 'Failed to generate challenge', loading: false });
      throw err;
    }
  },

  completeDay: async (id, dayNumber) => {
    set({ loading: true, error: null });
    try {
      const updatedChallenge = await challengeService.completeChallengeDay(id, dayNumber);
      set((state) => ({
        activeChallenge: state.activeChallenge?.id === id ? updatedChallenge : state.activeChallenge,
        challenges: state.challenges.map(c => c.id === id ? updatedChallenge : c),
        loading: false
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to complete day', loading: false });
      throw err;
    }
  },

  toggleChallengeExercise: async (id, dayNumber, exerciseId) => {
    try {
      const updatedChallenge = await challengeService.toggleChallengeExercise(id, dayNumber, exerciseId);
      set((state) => ({
        activeChallenge: state.activeChallenge?.id === id ? updatedChallenge : state.activeChallenge,
        challenges: state.challenges.map(c => c.id === id ? updatedChallenge : c)
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to toggle exercise' });
      throw err;
    }
  },

  abandonChallenge: async (id) => {
    set({ loading: true, error: null });
    try {
      const updatedChallenge = await challengeService.abandonChallenge(id);
      set((state) => ({
        activeChallenge: state.activeChallenge?.id === id ? null : state.activeChallenge,
        challenges: state.challenges.map(c => c.id === id ? updatedChallenge : c),
        loading: false
      }));
    } catch (err) {
      set({ error: err.message || 'Failed to abandon challenge', loading: false });
      throw err;
    }
  }
}));
