<template>
    <div class="WorkingTime">
      <h2>WorkingTime</h2>
  
      <div class="create_working_time">
        <p>Create a WorkingTime</p>
        <form @submit.prevent="createWorkingTime">
          <input v-model="createStartTime" aria-label="Start Time" type="text" placeholder="Start Time" />
          <input v-model="createEndTime" aria-label="End Time" type="text" placeholder="End Time" />
          <button type="submit">Create</button>
        </form>
      </div>
  
      <div class="update_working_time">
        <p>Update a WorkingTime</p>
        <form @submit.prevent="updateWorkingTime">
          <input v-model="updateStartTime" aria-label="Start Time" type="text" placeholder="Start Time" />
          <input v-model="updateEndTime" aria-label="End Time" type="text" placeholder="End Time" />
          <button type="submit">Update</button>
        </form>
      </div>
  
      <div class="delete_working_time">
        <p>Delete a WorkingTime</p>
        <form @submit.prevent="deleteWorkingTime">
          <input v-model="deleteStartTime" aria-label="Start Time" type="text" placeholder="Start Time" />
          <input v-model="deleteEndTime" aria-label="End Time" type="text" placeholder="End Time" />
          <button type="submit">Delete</button>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    name: 'WorkingTime',
    data() {
      return {
        createStartTime: '',
        createEndTime: '',
        updateStartTime: '',
        updateEndTime: '',
        deleteStartTime: '',
        deleteEndTime: '',
      };
    },
    methods: {
      async createWorkingTime() {
        try {
          const response = await axios.post('http://localhost:4000/api/workingtimes', {
            start: this.createStartTime,
            end: this.createEndTime,
          });
          console.log('Created Working Time:', response.data);
        } catch (error) {
          console.error('Error creating working time:', error);
        }
      },
      async updateWorkingTime() {
        try {
          const response = await axios.put('http://localhost:4000/api/workingtimes/7', {
            start: this.updateStartTime,
            end: this.updateEndTime,
          });
          console.log('Updated Working Time:', response.data);
        } catch (error) {
          console.error('Error updating working time:', error);
        }
      },
      async deleteWorkingTime() {
        try {
          const response = await axios.delete('http://localhost:4000/api/workingtimes/7');
          console.log('Deleted Working Time:', response.data);
        } catch (error) {
          console.error('Error deleting working time:', error);
        }
      },
    },
  };
  </script>
  
  <style>
  /* Add your styles here */
  </style>
  