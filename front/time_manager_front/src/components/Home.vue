<template>
  <div class="container">
    <h1>Welcome to TimeManager</h1>
    <div v-if="!user" class="auth-form">
      <form @submit.prevent="isRegistering ? register() : login()">
        <div>
          <label for="email">Email:</label>
          <input type="email" id="email" v-model="email" required />
        </div>
        <div>
          <label for="password">Password:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <div v-if="isRegistering">
          <label for="username">Username:</label>
          <input type="text" id="username" v-model="username" required />
        </div>
        <button type="submit" class="submit-button">{{ isRegistering ? 'Register' : 'Login' }}</button>
        <button type="button" @click="toggleAuthMode" class="toggle-button">
          {{ isRegistering ? 'Already have an account? Login' : 'Need an account? Register' }}
        </button>
      </form>
      <p v-if="error" class="error">{{ error }}</p>
    </div>
    <div v-else class="user-welcome">
      <p>Welcome, {{ user.username }}!</p>
      <!-- Logout functionality can be included here if needed -->
    </div>
  </div>
</template>


<script>
 // Home.vue
 import { authState,setAuthUser, clearAuthUser, apiClient, setAxiosAuthHeader } from '../store/authState';


 export default {
   name: 'Home',
   data() {
     return {
       email: '',
       password: '',
       username: '',
       user: null,
       token: '',
       isRegistering: false,
       error: '', // To store error messages from login/register attempts
      };
    },
   created() {
     this.retrieveSession();
    },
   methods: {
      async login() {
        try {
          const response = await apiClient.post('/login', {
            user: { email: this.email, password: this.password },
          });
          this.handleAuthResponse(response);
          this.$router.push({ name: 'dashboard' });
        } catch (error) {
           this.handleError(error);
          }
      },
      async register() {
        try {
          const response = await apiClient.post('/register', {
            user: { email: this.email, password: this.password, username: this.username },
          });
          this.handleAuthResponse(response);
          this.$router.push({ name: 'dashboard' });
        } catch (error) {
           this.handleError(error);
          }
      },
    handleAuthResponse(response) {
     setAuthUser(response.data.data.user);
     setAxiosAuthHeader(response.data.data.token); 
     this.user = response.data.data.user;
     this.token = response.data.data.token;
     this.clearAuthFields();
    },
    clearAuthFields() {
      this.email = '';
      this.password = '';
      this.username = '';
      this.error = '';
    },
   
    logout() {
      // Clear the user from authState and the Axios auth header
      clearAuthUser();
      delete apiClient.defaults.headers.common['Authorization'];
      this.user = null;
      this.token = '';
      this.$router.push('/home');
    },
    toggleAuthMode() {
      this.isRegistering = !this.isRegistering;
    },
    handleError(error) {
      this.error = 'An error occurred. Please try again.';
      console.error('Error:', error);
    },
    retrieveSession() {
      // Use the global auth state to check if the user is already logged in
      if (authState.isAuthenticated) {
       this.user = authState.user;
       this.token = authState.token;
        
      }
    }
  },
};
</script>

<style>
.container {
  max-width: 400px;
  margin: 50px auto;
  padding: 20px;
  text-align: center;
}

h1 {
  color: #333;
  margin-bottom: 20px;
}

.auth-form {
  background-color: #f9f9f9;
  border: 1px solid #ddd;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.auth-form form div {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #555;
}

input[type="email"],
input[type="password"],
input[type="text"] {
  width: 100%;
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  box-sizing: border-box;
}

.submit-button {
  background-color: #5cb85c;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  width: 100%;
  margin-top: 10px;
}

.submit-button:hover {
  background-color: #4cae4c;
}

.toggle-button {
  background: none;
  border: none;
  color: #337ab7;
  text-decoration: underline;
  padding: 10px;
  font: inherit;
  cursor: pointer;
  width: 100%;
  margin-top: 10px;
}

.error {
  color: red;
  margin-top: 15px;
}

.user-welcome {
  margin-top: 20px;
  background-color: #dff0d8;
  padding: 10px;
  border-radius: 4px;
}

.user-welcome p {
  margin: 0;
  color: #3c763d;
}
</style>
