//导入 vue对象的函数createApp
import {createApp} from 'vue'
//导入第一个vue的页面（是所有的vue页面的入口）
// 导入组件或者函数、对象等等 ，导入的是一个文件的默认导出，导入的就不用加{} 否要不用加大括号
import App from './App.vue'
//导入router对象
import router from './router'
//导入pinia的createPinia函数
import {createPinia} from 'pinia'
//导入持久化对象
import persistedstate from 'pinia-plugin-persistedstate'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'

//调用createApp函数生成vue对象（这个vue对象就是viewmodel，把数据model和现实view进行最大限制的分离）
//调用createApp函数过程中，把第一个App.vue页面作为参数传进去，这样vue对象就可以控制App.vue页面了
const app = createApp(App)
//使用router，这样router才能生效
app.use(router)
//创建pinia对象
const pinia = createPinia()
//pinia对象state数据持久化
pinia.use(persistedstate)
//app要使用pinia对象
app.use(pinia)
app.use(ElementPlus)
//把图标库中所有图标组件注册成全局组件，key就是图标名称 value就是图标组件对象
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
    app.component(key, component)
}

//app的vue对象挂载到id为app的html元素的DOM对象上，控制DOM对象和及其子元素
app.mount('#app')
