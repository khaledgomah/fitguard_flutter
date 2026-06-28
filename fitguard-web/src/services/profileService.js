import apiClient from './apiClient';

export const profileService = {
  getProfile: async () => {
    const response = await apiClient.get('/user/profile');
    return response.data;
  },

  updateProfile: async (profileData) => {
    const response = await apiClient.put('/user/profile', profileData);
    return response.data;
  },

  updateSettings: async (settings) => {
    const response = await apiClient.put('/user/settings', { settings });
    return response.data;
  },

  updateDevices: async (devices) => {
    const response = await apiClient.put('/user/devices', { devices });
    return response.data;
  }
};
