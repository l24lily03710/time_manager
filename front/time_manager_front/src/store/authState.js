import { reactive } from 'vue';
import axios from 'axios'; 

// Create an Axios instance and set the base URL
const apiClient = axios.create({
  baseURL: 'http://localhost:8000'
});
export const authState = reactive({
  user: JSON.parse(localStorage.getItem('user')) || null,
  token: localStorage.getItem('token') || null,
  isAuthenticated: !!localStorage.getItem('token'),
  role: null, // Add a role field to authState
  userId: null, // Add a userId field to authState
});

export function setAxiosAuthHeader(token) {
  if (token) {
    // Set the Authorization header on the Axios instance
    apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
    localStorage.setItem('token', token);
  } else {
    // Remove the Authorization header if the token is not present
    delete apiClient.defaults.headers.common['Authorization'];
    localStorage.removeItem('token');
  }
}

export function setAuthUser(user) {
  authState.user = user;
  authState.isAuthenticated = !!user;
  authState.userId = user ? user.id : null; 
  authState.role = determineUserRole(user);
  localStorage.setItem('user', JSON.stringify(user));
  
}

export function clearAuthUser() {
  authState.user = null;
  authState.isAuthenticated = false;
  authState.role = null; // Clear the user's role
  authState.userId = null; // Clear the user's ID
  localStorage.removeItem('user');
  localStorage.removeItem('token');
}

function determineUserRole(user) {
  return user && user.id === 1 ? 'admin' : 'user';
}

export { apiClient };
