import { createRouter, createWebHistory } from 'vue-router';
import { authState } from '../store/authState';
const routes = [
  {
    path: '/home',
    name: 'home',
    component: () => import(/* webpackChunkName: "home" */ '../components/Home.vue'),
  },
  {
    path: '/dashboard',
    name: 'dashboard',
    component: () => import(/* webpackChunkName: "dashboard" */ '../components/Dashboard.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin', 'user'] },
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import(/* webpackChunkName: "profile" */ '../components/Profile.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin', 'user'] },
  },
  {
    path: '/usermanager',
    name: 'usermanager',
  
    component: () => import(/* webpackChunkName: "usremanager" */ '../components/UserManager.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin'] }, // Only admin
  },
  {
    path: '/clockmanager',
    name: 'clockmanager',
 
    component: () => import(/* webpackChunkName: "clockmanager" */ '../components/ClockManager.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin', 'user'] }, 
  },
  {
    path: '/workingtimes',
    name: 'workingtimes',

    component: () => import(/* webpackChunkName: "workingtimes" */ '../components/WorkingTimes.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin', 'user'] }, // Only admin
  },
  {
    path: '/workingtime',
    name: 'workingtime',

    component: () => import(/* webpackChunkName: "workingtime" */ '../components/WorkingTime.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin', 'user'] },
  },
  {
    path: '/chartmanager',
    name: 'chartmanager',

    component: () => import(/* webpackChunkName: "chartmanager" */ '../components/ChartManager.vue'),
    meta: { requiresAuth: true, allowedRoles: ['admin', 'user'] }, // Only admin
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});
import { ref } from 'vue';
export const errorMessage = ref('');
router.beforeEach((to, from, next) => {
  errorMessage.value = '';
  // Check if the route requires authentication
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // If the user is not authenticated
    if (!authState.isAuthenticated) {
      next('/home');
    } else if (to.meta.allowedRoles && !to.meta.allowedRoles.includes(authState.role)) {
      // Role not allowed
      errorMessage.value = 'You are not authorized to view this page.';
      next(from.name ? false : { name: 'dashboard' }); // Stay or redirect to dashboard
    } else {
      // Role allowed
      next();
    }
  } else {
    // No authentication required
    next();
  }
});

export default router;