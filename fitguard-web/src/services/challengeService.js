import apiClient from './apiClient';

export const challengeService = {
  generateChallenge: async (challengeParams) => {
    const response = await apiClient.post('/challenges/generate', challengeParams);
    return response.data;
  },

  getChallenges: async () => {
    const response = await apiClient.get('/challenges');
    return response.data;
  },

  getActiveChallenge: async () => {
    const response = await apiClient.get('/challenges/active');
    return response.data;
  },

  completeChallengeDay: async (id, dayNumber) => {
    const response = await apiClient.put(`/challenges/${id}/day/${dayNumber}/complete`);
    return response.data;
  },

  toggleChallengeExercise: async (id, dayNumber, exerciseId) => {
    const response = await apiClient.put(`/challenges/${id}/day/${dayNumber}/exercise/${exerciseId}/toggle`);
    return response.data;
  },

  abandonChallenge: async (id) => {
    const response = await apiClient.put(`/challenges/${id}/abandon`);
    return response.data;
  },

  getChallengeById: async (id) => {
    const response = await apiClient.get(`/challenges/${id}`);
    return response.data;
  }
};
