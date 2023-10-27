<template>
    <div>
      <h1>Clock Manager for {{ username }}</h1>
      <p v-if="clockIn">Clock In Time: {{ startDateTime }}</p>
      <button @click="clockAction">{{ clockIn ? 'Clock Out' : 'Clock In' }}</button>
      <button @click="refresh">Refresh</button>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        username: this.$route.params.username, 
        startDateTime: null, 
        clockIn: false, 
      };
    },
    methods: {
      clockAction() {
        
        if (this.clockIn) {
          this.clockOut();
        } else {
          this.clockInAction();
        }
      },
      async clockInAction() {
       
        try {
           await this.$http.post(`/clocks/yourClockID`, { clock: { clock_in: true } });
           this.startDateTime = new Date();
           this.clockIn = true;
        } catch (error) {
          console.error("Clock In failed:", error);
        }
      },
      async clockOut() {
       
        try {
          await this.$http.put(`/clocks/yourClockID`, { clock: { clock_out: true } });
          this.startDateTime = null;
          this.clockIn = false;
        } catch (error) {
          console.error("Clock Out failed:", error);
        }
      },
      async refresh() {
        
        this.fetchClockStatus();
      },
      async fetchClockStatus() {
        
        try {
          const response = await this.$http.get(`/clocks/yourUserID`);
          const clock = response.data.clock; 
          this.startDateTime = clock.start_date_time;
          this.clockIn = clock.clock_in;
        } catch (error) {
          console.error("Failed to fetch clock status:", error);
        }
      },
    },
    created() {
      
      this.fetchClockStatus();
    },
  };
  </script>
  