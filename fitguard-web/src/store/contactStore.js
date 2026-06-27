import { create } from 'zustand';
import { contactService } from '../services/contactService';

export const useContactStore = create((set) => ({
  loading: false,
  error: null,
  success: false,

  submitInquiry: async (data) => {
    set({ loading: true, error: null, success: false });
    try {
      await contactService.submitInquiry(data);
      set({ loading: false, success: true });
      return true;
    } catch (err) {
      set({ 
        error: err.response?.data?.error || err.response?.data?.message || err.message || 'Failed to submit inquiry', 
        loading: false 
      });
      return false;
    }
  },
  
  resetStatus: () => set({ error: null, success: false, loading: false })
}));
