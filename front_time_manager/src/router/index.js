import { createRouter, createWebHistory } from 'vue-router';
import ClockManager from '../components/ClockManager.vue';
import UserManager from '../components/UserManager.vue';

const routes = [
  {
    path: '/user-manager',
    name: 'user-manager',
    component: UserManager, 
  },
  {
    path: '/clock/:username', 
    name: 'clock-manager',
    component: ClockManager   
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
