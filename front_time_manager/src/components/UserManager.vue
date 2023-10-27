<template>
  <div class="UserManager">
    <header>
      <h2>User Manager</h2>
    </header>
    <main>
      <button @click="showUsers">Show Users</button>
      <button @click="createUser">Create User</button>
      <button @click="modifyUser">Modify User</button>
      <button @click="deleteUser">Delete User</button>
    </main>
    <div>
      <h3>Show User</h3>
      <div>
        <label for="userId">User ID:</label>
        <input type="text" id="userId" v-model="searchUserId" />
        <button @click="showUser">Show</button>
      </div>

      <div v-if="showUserSection">
        <p><strong>Name:</strong> {{ user.name }}</p>
        <p><strong>Email:</strong> {{ user.email }}</p>
      </div>
    </div>
    <div v-if="createUserSection">
      <h3>Create User</h3>
      <input v-model="newUser.name" placeholder="Name" />
      <input v-model="newUser.email" placeholder="Email" />
      <button @click="addUser">Create</button>
    </div>
    <div v-if="modifyUserSection">
      <h3>Modify User</h3>
      <input v-model="modifyUserId" placeholder="User ID" />
      <input v-model="modifyUser.name" placeholder="New Name" />
      <input v-model="modifyUser.email" placeholder="New Email" />
      <button @click="updateUser">Modify</button>
    </div>
    <div v-if="deleteUserSection">
      <h3>Delete User</h3>
      <input v-model="deleteUserId" placeholder="User ID" />
      <button @click="removeUser">Delete</button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showUserSection: false,
      createUserSection: false,
      modifyUserSection: false,
      deleteUserSection: false,
      searchUserId: '',
      user: {
        name: '',
        email: '',
      },
      newUser: {
        name: '',
        email: '',
      },
      modifyUserId: '',
      modifyUser: {
        name: '',
        email: '',
      },
      deleteUserId: '',
    };
  },
  methods: {
    async showUser() {
      try {
        const response = await fetch(`/api/users/${this.searchUserId}`);
        if (response.ok) {
          const userData = await response.json();
          this.showUserSection = true;
          this.user = userData;
        } else {
          console.error('Error fetching user:', response.statusText);
        }
      } catch (error) {
        console.error('Error fetching user:', error);
      }
    },

    async addUser() {
      const userToAdd = {
        name: this.newUser.name,
        email: this.newUser.email,
      };

      try {
        const response = await fetch('/api/users', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(userToAdd),
        });

        if (response.ok) {
          this.createUserSection = false;
          this.newUser = { name: '', email: '' };
          alert('User created successfully');
        } else {
          const data = await response.json();
          console.error('Error creating user:', data.error);
        }
      } catch (error) {
        console.error('Error creating user:', error);
      }
    },

    async updateUser() {
      const userToUpdate = {
        name: this.modifyUser.name,
        email: this.modifyUser.email,
      };

      try {
        const response = await fetch(`/api/users/${this.modifyUserId}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(userToUpdate),
        });

        if (response.ok) {
          this.modifyUserSection = false;
          this.modifyUserId = '';
          this.modifyUser = { name: '', email: '' };
          alert('User updated successfully');
        } else {
          console.error('Error updating user:', response.statusText);
        }
      } catch (error) {
        console.error('Error updating user:', error);
      }
    },

    async removeUser() {
      try {
        const response = await fetch(`/api/users/${this.deleteUserId}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          this.deleteUserSection = false;
          this.deleteUserId = '';
          alert('User deleted successfully');
        } else {
          console.error('Error deleting user:', response.statusText);
        }
      } catch (error) {
        console.error('Error deleting user:', error);
      }
    },
  },
};
</script>

<style scoped>
.user-manager {
  text-align: center;
}

button {
  margin: 10px;
}
</style>

  