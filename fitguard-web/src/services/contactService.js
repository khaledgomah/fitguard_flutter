import apiClient from './apiClient';

export const contactService = {
  submitInquiry: async (data) => {
    const response = await apiClient.post('/contact', data);
    return response.data;
  }
};
