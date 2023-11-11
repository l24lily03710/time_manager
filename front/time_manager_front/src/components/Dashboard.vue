<template>
    <div class="dashboard">
      <h1>Welcome to TimeManager</h1>
      <div class="options">
        <router-link v-if="isAdmin" :to="{ name: 'usermanager' }" class="option">
          <i class="fa fa-users"></i>
          <span>User Manager</span>
        </router-link>
        <router-link :to="{ name: 'clockmanager' }" class="option">
          <i class="fa fa-clock"></i>
          <span>Clock Manager</span>
        </router-link>
        <router-link  :to="{ name: 'workingtimes' }" class="option">
          <i class="fa fa-calendar"></i>
          <span>Working Times</span>
        </router-link>
        <router-link :to="{ name: 'workingtime' }" class="option">
          <i class="fa fa-calendar-alt"></i>
          <span>Working Time</span>
        </router-link>
        <router-link :to="{ name: 'chartmanager' }" class="option">
          <i class="fa fa-chart-bar"></i>
          <span>Chart Manager</span>
        </router-link>
        <router-link :to="{ name: 'profile' }" class="option">
          <i class="fa fa-user"></i>
          <span>Profile</span>
        </router-link>
      </div>
    </div>
  </template>
  
<script>
  import { authState } from '../store/authState'; 
  export default {
    name: 'Dashboard',
    computed: {
     isAdmin() {
       return authState.role === 'admin';
      },
    },
  };
</script>
<style scoped>
.dashboard {
  text-align: center;
  padding: 20px;
}

.dashboard h1 {
  color: #333;
  margin-bottom: 20px;
}

.options {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 20px;
  margin-top: 20px;
}

.option {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-decoration: none;
  color: #555;
  border: 1px solid #ddd;
  padding: 15px;
  border-radius: 8px;
  background-color: #f9f9f9;
  transition: all 0.3s ease;
}

.option:hover {
  color: #007bff;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  transform: translateY(-5px);
}

.option i {
  font-size: 30px;
  margin-bottom: 10px;
}

.option span {
  font-size: 16px;
  font-weight: 500;
}

/* Highlight the active link */
.option.router-link-active {
  border-color: #007bff;
  color: #007bff;
  font-weight: bold;
}
</style>
