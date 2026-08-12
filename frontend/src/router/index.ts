//导入必要路由的方法和组件
import {createRouter, createWebHistory, type RouteRecordRaw} from 'vue-router'
import { useUserStore } from '@/stores/user'

//配置路由规则：url对应的哪个页面
const routes: Array<RouteRecordRaw> = [
    {
        //当访问 / 就会跳转访问/main
        path: '/',
        redirect: 'welcome'
    },
    {
        path: "/welcome",
        name: "welcome",
        component: () => import('../views/welcome.vue')
    },
    {
        path: "/user-login",
        name: "userLogin",
        component: () => import('../views/user/UserLogin.vue')
    },
    {
        path: "/user-register",
        name: "userRegister",
        component: () => import('../views/user/UserRegister.vue')
    },
    {
        path: "/user-dashboard",
        name: "userDashboard",
        component: () => import('../views/user/UserDashboard.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/user/charging-stations",
        name: "chargingStations",
        component: () => import('../views/user/ChargingStationsView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/user/charging-service",
        name: "chargingService",
        component: () => import('../views/user/ChargingServiceOptions.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/user/use-charger",
        name: "useCharger",
        component: () => import('../views/user/UseChargerView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/charging/:id",
        name: "chargingDetail",
        component: () => import('../views/user/ChargingDetailView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/station/:id",
        redirect: to => `/booking/detail/${to.params.id}`
    },
    {
        path: "/booking",
        name: "booking",
        component: () => import('../views/user/BookingView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/booking/detail/:id",
        name: "bookingDetail",
        component: () => import('../views/user/BookingDetailView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/history",
        name: "history",
        component: () => import('../views/user/HistoryView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/profile",
        name: "profile",
        component: () => import('../views/user/ProfileView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: "/user/news",
        name: "news",
        component: () => import('../views/user/NewsView.vue'),
        meta: { requiresAuth: true }
    },
]

//创建路由对象
const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes
})

//路由守卫 - 检查认证
router.beforeEach((to, from, next) => {
  const userStore = useUserStore()
  const isAuthenticated = !!userStore.getToken // 检查是否有token

  // 已登录用户访问登录/注册页面时，重定向到仪表板
  if ((to.path === '/user-login' || to.path === '/user-register') && isAuthenticated) {
    next('/user-dashboard')
    return
  }

  // 对于登录和注册页面，总是允许访问
  if (to.path === '/user-login' || to.path === '/user-register') {
    next()
    return
  }

  if (to.meta.requiresAuth && !isAuthenticated) {
    // 如果需要认证但用户未登录，重定向到登录页
    next('/user-login')
  } else {
    // 否则继续导航
    next()
  }
})

//默认导出路由对象，给全局的Vue对象挂在使用
export default router
