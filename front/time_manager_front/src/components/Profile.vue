<template>
  <div class="profile-container">
    <h1>User Profile</h1>
    <div class="profile-content">
      <div class="profile-info">
        <p><strong>Username:</strong> {{ authState.user.username }}</p>
        <p><strong>Email:</strong> {{ authState.user.email }}</p>
      </div>
      
      <div v-if="imageData.length > 0" class="profile-image">
        <h3>Image Preview:</h3>
        <img :src="imageData" alt="Profile image preview" class="image-preview" />
        <button @click="removeImage" class="remove-button">Remove Image</button>
      </div>

      <div v-else class="image-upload">
        <h2>Upload Profile Image</h2>
        <input type="file" @change="previewImage" />
      </div>
    </div>
  </div>
</template>

  
<script>
import { authState  } from '../store/authState'; 

export default {
    name: 'Profile',
    data() {
      return {
        imageData: '',
      };
    },
    computed: {
      // Using a computed property to ensure reactivity
      authState() {
        return authState;
      }
    },
    mounted() {
      console.log('Profile mounted, user:', this.authState.user);
    },
    methods: {
      previewImage(event) {
      const file = event.target.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.imageData = e.target.result;
        };
        reader.readAsDataURL(file);
      }
    },
    removeImage() {
      this.imageData = '';
    },
  },
};
</script>
  
<style scoped>
.profile-container {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  background-color: #fff;
  text-align: center;
}

.profile-container h1 {
  margin-bottom: 20px;
  color: #333;
}

.profile-container p {
  font-size: 18px;
  color: #555;
  margin: 10px 0;
}

.image-upload {
  margin-top: 30px;
  border-top: 1px solid #eee;
  padding-top: 20px;
}

.image-upload h2 {
  color: #333;
  margin-bottom: 15px;
}

.image-upload input[type="file"] {
  display: block;
  margin: 0 auto 20px;
  font-size: 16px;
}

.image-preview {
  max-width: 100%;
  height: auto;
  border-radius: 8px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}
.profile-content {
  display: flex;
  justify-content: space-around;
  align-items: center;
  margin-bottom: 30px;
}

.profile-info, .profile-image {
  flex-basis: 45%;
}

.remove-button {
  margin-top: 10px;
  padding: 10px 15px;
  background-color: #ff4d4f;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.remove-button:hover {
  background-color: #ff7875;
}

/* Add any additional styles you may need */
</style>
