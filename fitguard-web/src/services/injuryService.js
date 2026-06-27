import apiClient from './apiClient';

export const injuryService = {
  createInjury: async (injuryData) => {
    const response = await apiClient.post('/injuries', injuryData);
    return response.data;
  },

  getInjuries: async () => {
    const response = await apiClient.get('/injuries');
    return response.data;
  },

  getInjuryById: async (id) => {
    const response = await apiClient.get(`/injuries/${id}`);
    return response.data;
  },

  updateInjury: async (id, updateData) => {
    const response = await apiClient.put(`/injuries/${id}`, updateData);
    return response.data;
  },

  deleteInjury: async (id) => {
    const response = await apiClient.delete(`/injuries/${id}`);
    return response.data;
  },

  getInjuryPatterns: async () => {
    const response = await apiClient.get('/injuries/patterns');
    return response.data;
  }
};
