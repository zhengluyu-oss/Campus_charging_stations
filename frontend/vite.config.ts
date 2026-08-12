import {defineConfig} from 'vite'
import vue from '@vitejs/plugin-vue'
import {resolve} from 'path'

// https://vite.dev/config/
export default defineConfig({
    plugins: [vue()],
    resolve: {
        alias: {
            '@': resolve(__dirname, 'src'),
        }
    },
    //配置server(配置前端服务器)
    server: {
        //端口
        port: 8888,
        //监听当前前端服务所有ip地址（例如：127.0.0.1 localhost  192.168.120.200都可以）
        host: '0.0.0.0',
        proxy: {
            //请求以 /admin-api 开头的url 进行代理访问
            '/user-api': {
                //代理访问的目标地址 ，例如 访问 /admin-api/login   代理访问成 http://localhost:8081/admin-api/login
                target: 'http://localhost:8080',
                //允许跨域
                changeOrigin: true,
                //重写url
                //js的正则表达式 /正则匹配符/  /^\/admin-api/   正斜杠 / 在正则中是特殊字符 用反斜杠转义 \/ 把正斜杠 变成普通字符
                //最终访问：http://localhost:8081/login
                rewrite: ((path) => path.replace(/^\/user-api/, '/user'))
            },
            //配置充电桩API的请求代理
            '/api': {
                //代理访问的目标地址
                target: 'http://localhost:8080',
                //允许跨域
                changeOrigin: true
            },
            //配置充电相关接口的请求代理
            '/user': {
                //代理访问的目标地址
                target: 'http://localhost:8080',
                //允许跨域
                changeOrigin: true
            },
            //配置图片的请求代理
            '/image': {
                //代理访问的目标地址 ，例如 访问 /admin-api/login   代理访问成 http://localhost:8081/admin-api/login
                target: 'http://localhost:8080',
                //允许跨域
                changeOrigin: true
            },
            //配置预约接口的请求代理
            '/reversation': {
                //代理访问的目标地址
                target: 'http://localhost:8080',
                //允许跨域
                changeOrigin: true
            },
            //配置上传图片接口的请求代理
            '/upload': {
                target: 'http://localhost:8080',
                changeOrigin: true
            },
            //配置新闻接口的请求代理
            '/news': {
                target: 'http://localhost:8080',
                changeOrigin: true
            }
        }
    }
})
