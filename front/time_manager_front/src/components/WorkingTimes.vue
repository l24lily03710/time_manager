<template>
  <div class='workingtimes'>
    <h2>WorkingTimes</h2>
    <table>
      <tbody>
        <tr>
          <td>User ID</td>
          <td>{{ workTimes.user_id }}</td>
        </tr>
        <tr>
          <td>Start Time</td>
          <td>{{ formatTime(workTimes.start) }}</td>
        </tr>
        <tr>
          <td>End Time</td>
          <td>{{ formatTime(workTimes.end) }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
  
<script>
import axios from 'axios';

export default {
  name: 'WorkingTimes',
  data() {
    return {
      workTimes: {}
    };
  },
  mounted() {
    this.fetchUserData();
  },
  methods: {
    async fetchUserData() {
      try {
        const response = await axios.get('http://localhost:4000/api/workingtimes/1/2');
        this.workTimes = response.data;
        console.log(response.data);
      } catch (error) {
        console.error('Error fetching working times data:', error);
      }
    },
    formatTime(timeString) {
      const time = new Date(timeString);
      return time.toLocaleString(); 
    }
  }
};
</script>

<style>
  .workingtimes {
    width: 400px;
    border: 2px solid black;
    margin: auto;
  }
  td{
    text-align: left;
  }
</style>
