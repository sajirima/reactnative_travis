import axios from 'axios';
import { Alert, Platform } from 'react-native';

const port = '3000';

const configuredBaseUrl = process.env.EXPO_PUBLIC_API_BASE_URL?.trim();
const defaultHost =
  Platform.OS === 'android' ? '10.0.2.2' : Platform.OS === 'ios' ? 'localhost' : 'localhost';
const baseURL = configuredBaseUrl ?? `http://${defaultHost}:${port}`;

const api = axios.create({
  baseURL,
  timeout: 8000,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (!error.response) {
      Alert.alert(
        'Network Error',
        "Can't connect to the server. Please check your network connection or ensure the server is running."
      );
    }

    return Promise.reject(error);
  }
);

export default api;
