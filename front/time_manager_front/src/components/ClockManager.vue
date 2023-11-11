<template>
  <div>
    <h2>Clock Manager</h2>

    <div v-if="clockStatus">
      <p>Work period started at : {{ startDateTime }}</p>
      <p>Time Elapsed: {{ elapsedTime }}</p>
      <button @click="performClockOut">Clock Out</button>
    </div>
    <div v-else>
      <button @click="performClockIn">Clock In</button>
    </div>
  </div>
</template>

<script>
  import { authState, apiClient } from '../store/authState';
  export default {
    name: 'ClockManager',  
    data() {
      return {
        clockStatus: false, 
        startDateTime: null,
        stopwatchInterval: null,
        elapsedTime: '00:00:00',
      };
    },
    computed: {
      userId() {
        return authState.userId; // Accessing the userId from authState
      }
    },
  
    methods: {
      async performClockOut() {
        try {
          await apiClient.post(`/api/clocks/${this.userId}`, { clock: { time: new Date().toISOString(), status: false } });
          this.clockStatus = false;
          this.startDateTime = null;
          this.stopStopwatch();
        } catch (error) {
           console.error('Error during clock out:', error);
          }
      },
      formatDateTime(date) {
        const pad = (num) => (num < 10 ? '0' + num : num);
        const year = date.getFullYear();
        const month = pad(date.getMonth() + 1);
        const day = pad(date.getDate());
        const hours = pad(date.getHours());
        const minutes = pad(date.getMinutes());
        const seconds = pad(date.getSeconds());
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
      },
      startStopwatch() {
        const startTime = new Date(this.startDateTime);
        this.stopwatchInterval = setInterval(() => {
          const currentTime = new Date();
          const difference = currentTime - startTime;

          let hours = Math.floor(difference / 3600000);
          let minutes = Math.floor((difference % 3600000) / 60000);
          let seconds = Math.floor((difference % 60000) / 1000);

          hours = hours < 10 ? '0' + hours : hours;
          minutes = minutes < 10 ? '0' + minutes : minutes;
          seconds = seconds < 10 ? '0' + seconds : seconds;

          this.elapsedTime = `${hours}:${minutes}:${seconds}`;
        }, 1000);
      },
    
      async performClockIn() {
     
        // Perform the clock in with the fetched user ID
        try {
          this.startDateTime = this.formatDateTime(new Date());
          await apiClient.post(`/api/clocks/${this.userId}`, {
            clock: { time: this.startDateTime, status: true }
          });
          this.clockStatus = true;
          this.startStopwatch();
        } catch (error) {
           console.error('Error during clock in:', error);
          }
      },

      async refresh() { 
        try {
         const response = await apiClient.get(`/api/clocks/${this.userId}`);
         if (response.data && response.data.clocks && response.data.clocks.length) {
           const latestClock = response.data.clocks[0];
           this.startDateTime = this.formatDateTime(new Date(latestClock.time));
           this.clockStatus = latestClock.status;
          } else {
           this.clockStatus = false;
           this.startDateTime = null;
          }
        } catch (error) {
            if (error.response) {
             // The request was made and the server responded with a status code
             // that falls out of the range of 2xx
             console.error('Error data:', error.response.data);
             console.error('Error status:', error.response.status);
             console.error('Error headers:', error.response.headers);
            } else if (error.request) {
                // The request was made but no response was received
                console.error('Error request:', error.request);
              } else {
                 // Something happened in setting up the request that triggered an Error
                 console.error('Error message:', error.message);
                }
          }
      },
     stopStopwatch() {
        clearInterval(this.stopwatchInterval);
        this.elapsedTime = '00:00:00';
      },
    },
  
    mounted() {
  
     this.refresh();
    },
    beforeUnmount() {
      this.stopStopwatch();
    },
  };  
  
</script>

<style scoped>
.clock-manager {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  background-color: #fff;
  text-align: center;
}

.clock-manager h2 {
  margin-bottom: 20px;
  color: #333;
}

.time-info {
  font-size: 18px;
  color: #555;
  margin: 15px 0;
}

.button {
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  background-color: #007bff;
  color: white;
  cursor: pointer;
  transition: background-color 0.3s;
}

.button:hover {
  background-color: #0056b3;
}

.button:disabled {
  background-color: #cccccc;
  cursor: default;
}

/* Style for elapsed time display */
.elapsed-time {
  font-weight: bold;
  color: #007bff;
  margin-top: 15px;
}

/* Add any additional styles as needed */
</style>
