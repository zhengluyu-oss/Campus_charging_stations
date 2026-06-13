import { createRouter, createWebHistory } from 'vue-router'
import { useAdminStore } from '@/stores/admin'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      redirect: '/dashboard',
    },
    {
      path: '/login',
      name: 'AdminLogin',
      component: () => import('@/views/AdminLogin.vue'),
      meta: { title: 'Admin Login', noAuth: true },
    },
    {
      path: '/dashboard',
      name: 'AdminDashboard',
      component: () => import('@/views/AdminDashboard.vue'),
      meta: { title: 'Dashboard' },
    },
    {
      path: '/users',
      name: 'UserManagement',
      component: () => import('@/views/UserManagement.vue'),
      meta: { title: 'User Management' },
    },
    {
      path: '/stations',
      name: 'StationManagement',
      component: () => import('@/views/StationManagement.vue'),
      meta: { title: 'Station Management' },
    },
    {
      path: '/orders',
      name: 'OrderManagement',
      component: () => import('@/views/OrderManagement.vue'),
      meta: { title: 'Order Management' },
    },
    {
      path: '/payments',
      name: 'PaymentManagement',
      component: () => import('@/views/PaymentManagement.vue'),
      meta: { title: 'Payment Management' },
    },
    {
      path: '/reservations',
      name: 'ReservationManagement',
      component: () => import('@/views/ReservationManagement.vue'),
      meta: { title: 'Reservation Management' },
    },
    {
      path: '/news',
      name: 'NewsManagement',
      component: () => import('@/views/NewsManagement.vue'),
      meta: { title: 'News Management' },
    },
    {
      path: '/settings',
      name: 'AdminSettings',
      component: () => import('@/views/AdminSettings.vue'),
      meta: { title: 'Settings' },
    },
  ],
})

router.beforeEach((to, _from, next) => {
  const adminStore = useAdminStore()
  if (!to.meta.noAuth && !adminStore.token) {
    next('/login')
  } else {
    next()
  }
})

export default router
