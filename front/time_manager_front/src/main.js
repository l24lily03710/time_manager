import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import { apiClient } from './store/authState'; 
const app = createApp(App);


// Assign apiClient to the Vue instance as $http for use in components
app.config.globalProperties.$http = apiClient; // Use apiClient instead of axios


// Use router
app.use(router);

// Mount the Vue application
app.mount('#app');
