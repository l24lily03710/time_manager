<template>
  <div class="user-manager">
    <!-- User Options -->
    <div class="search-area">
      <input v-model="searchUsername" placeholder="Enter Username" class="search-input">
      <input v-model="searchEmail" placeholder="Enter Email" class="search-input">
      <button @click="getUsersBySearch" class="search-button">Search</button>
      <button @click="getAllUsers" class="all-users-button">Get All Users</button>
    </div>

    <!-- Displaying List of Users -->
    <div v-if="usersList.length > 0" class="user-list">
      <h3>Users</h3>
      <div v-for="user in usersList" :key="user.id" class="user-info">
        <p><span>ID:</span> {{ user.id }} <span>Username:</span> {{ user.username }} <span>Email:</span> {{ user.email }}</p>
        <button @click="deleteUser(user.id)" class="delete-button">Delete</button>
      </div>
    </div>

    <!-- Popup Message -->
    <div v-if="popupMessage" class="popup">
      {{ popupMessage }}
    </div>
  </div>
</template>

<script>
import { authState, apiClient, setAxiosAuthHeader } from '../store/authState';

export default {
  name: 'UserManager',
  data() {
    return {
      searchUsername: '',
      searchEmail: '',
      popupMessage: '',
      usersList: [],
      fetched: false, // Add a flag to check if users are fetched
    };
  },
  methods: {
    async getUsersBySearch() {
     let query = {};
 
     // Add username and/or email to the query if they are provided
     if (this.searchUsername) query.username = this.searchUsername;
     if (this.searchEmail) query.email = this.searchEmail;

     try {
       const response = await apiClient.get('/api/users', { params: query });
       this.usersList = response.data.data;
       if (this.usersList.length > 0) {
         this.showPopup('Users fetched successfully');
        } else {
           this.showPopup('No users found');
          }
      } catch (error) {
         this.showPopup('Error fetching users: ' + (error.response?.data?.message || error.message));
        }
    },
    async getAllUsers() {
      try {
        const response = await apiClient.get('/api/users');
        this.usersList = response.data.data;
        this.fetched = true; // Set the flag to true
        this.showPopup('Users list fetched successfully');
      } catch (error) {
        this.showPopup('Error fetching users list: ' + (error.response.data.message || error.message));
      }
    },
    async deleteUser(userId) {
      try {
        await apiClient.delete(`/api/users/${userId}`);
        this.showPopup('User deleted successfully');
        this.getAllUsers(); // Refresh the list of users
      } catch (error) {
        this.showPopup('Error deleting user: ' + (error.response.data.message || error.message));
      }
    },
    showPopup(message) {
      this.popupMessage = message;
      setTimeout(() => {
        this.popupMessage = '';
      }, 3000);
    },
  },
  mounted() {
    if (authState.token) {
      setAxiosAuthHeader(authState.token);
    }
    // Removed the automatic call to getAllUsers to prevent immediate display of all users
  },
};
</script>

<style scoped>
.user-manager {
  max-width: 800px;
  margin: auto;
  padding: 20px;
}

.search-area {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.search-input {
  flex-grow: 1;
  margin-right: 10px;
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

.search-button, .all-users-button {
  padding: 8px 15px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.search-button:hover, .all-users-button:hover {
  background-color: #0056b3;
}

.user-list {
  margin-top: 20px;
}

.user-info {
  background-color: #f4f4f4;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 10px;
  margin-bottom: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.user-info p {
  margin: 0;
  font-size: 0.9rem;
}

.user-info p span {
  font-weight: bold;
}

.delete-button {
  padding: 6px 12px;
  background-color: #dc3545;
  border: none;
  color: white;
  border-radius: 4px;
  cursor: pointer;
}

.delete-button:hover {
  background-color: #c82333;
}

.popup {
  position: fixed;
  top: 10px;
  right: 10px;
  padding: 10px;
  background-color: #f8d7da;
  border: 1px solid #f5c6cb;
  border-radius: 5px;
  color: #721c24;
}
@media (max-width: 768px) {
    .search-area {
      flex-direction: column;
      align-items: stretch;
    }

    .search-input, .search-button, .all-users-button {
      margin-bottom: 10px;
    }
  }
</style>
