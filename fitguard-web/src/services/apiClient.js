import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5001/api';

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // For refresh token cookies if used
});

// Flag to prevent multiple concurrent token refresh requests
let isRefreshing = false;
let failedQueue = [];

const processQueue = (error, token = null) => {
  failedQueue.forEach(prom => {
    if (error) {
      prom.reject(error);
    } else {
      prom.resolve(token);
    }
  });
  failedQueue = [];
};

// Request Interceptor: Attach JWT Token
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('access_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response Interceptor: Handle Global Errors & Token Refresh
apiClient.interceptors.response.use(
  (response) => {
    if (response.data && response.data.success !== undefined && response.data.data !== undefined) {
      const transformIds = (obj) => {
        if (Array.isArray(obj)) {
          return obj.map(transformIds);
        } else if (obj !== null && typeof obj === 'object') {
          const newObj = { ...obj };
          if (newObj._id) {
            newObj.id = newObj._id.toString();
          }
          for (const key in newObj) {
            if (key !== '_id' && key !== 'id') {
              newObj[key] = transformIds(newObj[key]);
            }
          }
          return newObj;
        }
        return obj;
      };

      const transformedData = transformIds(response.data.data);
      if (response.data.data.accessToken) {
        transformedData.access_token = response.data.data.accessToken;
      }
      response.data = transformedData;
    }
    return response;
  },
  async (error) => {
    const originalRequest = error.config;

    // Handle 401 Unauthorized (Token Expiration)
    if (error.response?.status === 401 && !originalRequest._retry) {
      // Don't intercept if it's the login or refresh route failing
      if (originalRequest.url.includes('/auth/login') || originalRequest.url.includes('/auth/refresh-token')) {
        return Promise.reject(error);
      }

      if (isRefreshing) {
        return new Promise(function (resolve, reject) {
          failedQueue.push({ resolve, reject });
        }).then(token => {
          originalRequest.headers.Authorization = `Bearer ${token}`;
          return apiClient(originalRequest);
        }).catch(err => {
          return Promise.reject(err);
        });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        // Attempt to refresh the token
        const refreshToken = localStorage.getItem('refresh_token');
        const response = await axios.post(`${API_BASE_URL}/auth/refresh-token`, { refreshToken }, {
          withCredentials: true // Assuming refresh token is in HttpOnly cookie, or adjust if payload based
        });

        const newAccessToken = response.data.data ? response.data.data.accessToken : response.data.access_token;
        const newRefreshToken = response.data.data ? response.data.data.refreshToken : response.data.refreshToken;

        if (newAccessToken) localStorage.setItem('access_token', newAccessToken);
        if (newRefreshToken) localStorage.setItem('refresh_token', newRefreshToken);

        apiClient.defaults.headers.common['Authorization'] = `Bearer ${newAccessToken}`;
        originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;

        processQueue(null, newAccessToken);
        return apiClient(originalRequest);
      } catch (refreshError) {
        processQueue(refreshError, null);
        // Force logout if refresh fails
        localStorage.removeItem('access_token');
        localStorage.removeItem('refresh_token');
        window.location.href = '/login'; // Native redirect since Zustand is banned for now
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    // Global Error Handling
    const errorMessage = error.response?.data?.message || error.message || 'An unexpected error occurred';
    console.error('API Error:', errorMessage);

    return Promise.reject(error);
  }
);

export default apiClient;
