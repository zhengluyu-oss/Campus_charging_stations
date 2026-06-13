import {defineStore} from 'pinia'
import {ref, computed} from 'vue'
import type {User} from "../viewmodel/UserModel.ts";

//useUserStore是一个函数（函数也是对象，是个特殊对象）
//useXXXStore 命名
export const useUserStore = defineStore(
    //id唯一标识
    'user',
    //函数 返回一个对象{state、getters、actions}
    () => {
        const token = ref<string>('')
        const getToken = computed(() => {
            return token.value
        })
        const saveToken = (value: string) => {
            token.value = value
        }
        const user = ref<User>()
        const getUser = computed(() => {
            return user.value
        })
        const saveUser = (value: User) => {
            user.value = value
        }
        //返回一个对象，响应式变量、计算属性、函数作为对对象属性
        return {
            token,
            getToken,
            saveToken,
            user,
            getUser,
            saveUser
        }
    },
    //配置持久化
    {
        persist: true
    }
)