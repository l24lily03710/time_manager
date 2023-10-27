javascript
 where in <template>
  <div class="App">
    <header>
      <h1>Time Manager</h1>
     
    </header>
    <main>
        <router-link to="/UserManager" class="functionality">
         <h2>User Manager</h2>
        </router-link>
        <router-link to="/ClockManager" class="functionality">
          <h2>Clock Manager</h2>
        </router-link>
        <router-link to="/WorkingTime" class="functionality">
          <h2>Working Time</h2>
        </router-link>
        <router-link to="/WorkingTimes" class="functionality">
          <h2>Working Times</h2>
        </router-link>
        <router-link to="/ChartManager" class="functionality">
          <h2>Chart Manager</h2>
        </router-link>
      <router-view></router-view>
    </main>
  </div>
</template>

<script>
export default {
  name: "App",
};
</script>

<style scoped>

.functionality-sections {
  display: flex;
  justify-content: center;
  align-items: center;
}

.functionality {
  width: 200px;
  height: 200px;
  margin: 20px;
  border: 1px solid #333;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
  cursor: pointer;
  text-decoration: none;
  color: #333;
}

.functionality:hover {
  background-color: #333;
  color: #fff;
}

.functionality h2 {
  margin-top: 20px;
}
</style>
