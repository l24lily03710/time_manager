<template>
  <div id="app">
    <!-- Navigation Bar -->
    <nav class="navbar">
      <div class="nav-links">
        <router-link to="/home">Home</router-link>
        <router-link v-if="isAuthenticated" to="/dashboard">Dashboard</router-link>
        <router-link v-if="isAuthenticated && isAdmin" to="/usermanager">User Manager</router-link>
        <router-link v-if="isAuthenticated" to="/clockmanager">Clock Manager</router-link>
        <router-link v-if="isAuthenticated" to="/workingtime">Working Time</router-link>
        <router-link v-if="isAuthenticated && isAdmin" to="/workingtimes">Working Times</router-link>
        <router-link v-if="isAuthenticated" to="/chartmanager">Chart Manager</router-link>
      </div>

      <div class="user-actions" v-if="isAuthenticated">
        <span class="username">{{ username }}</span>
        <div class="dropdown">
          <button class="dropbtn">▼</button>
          <div class="dropdown-content">
            <router-link to="/profile">Profile</router-link>
            <button @click="logoutUser">Logout</button>
          </div>
        </div>
      </div>
    </nav>

    <router-view />
    <div v-if="errorMessage" class="error-message">
      {{ errorMessage }}
    </div>
  </div>
</template>


<script>
  import { ref, computed } from 'vue';
  import { useRouter } from 'vue-router';
  import { authState, clearAuthUser } from './store/authState';


  export default {
    name: 'App',
    setup() {
      const router = useRouter();
      const isAuthenticated = computed(() => authState.isAuthenticated);
      const isAdmin = computed(() => authState.role === 'admin');
      const username = computed(() => authState.user?.username);

      const logoutUser = () => {
        clearAuthUser();
        router.push('/home');
      };

      return {
        isAuthenticated,
        isAdmin,
        username,
        logoutUser,
        errorMessage: ref(''), 
      };
    },
  };
</script>
<style>
.navbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #333;
  color: white;
  padding: 10px;
}

.nav-links a {
  color: white;
  text-decoration: none;
  margin-right: 15px;
}

.nav-links a:hover {
  text-decoration: underline;
}

.user-actions {
  position: relative;
}

.username {
  margin-right: 10px;
}

.dropbtn {
  background-color: #333;
  color: white;
  border: none;
  cursor: pointer;
}

.dropdown {
  position: relative;
  display: inline-block;
}

.dropdown-content {
  display: none;
  position: absolute;
  right: 0;
  background-color: #f9f9f9;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 1;
}

.dropdown-content a {
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {
  background-color: #f1f1f1;
}

.dropdown:hover .dropdown-content {
  display: block;
}

.dropdown:hover .dropbtn {
  background-color: #555;
}

.error-message {
  color: red;
  margin-top: 10px;
}
</style>
