import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  server: {
    port: 9999,
    host: '0.0.0.0',
    proxy: {
      '/admin-api': {
        target: 'http://localhost:8081',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/admin-api/, ''),
      },
      '/api': {
        target: 'http://localhost:8081',
        changeOrigin: true,
      },
      '/image': {
        target: 'http://localhost:8081',
        changeOrigin: true,
      },
      '/upload': {
        target: 'http://localhost:8081',
        changeOrigin: true,
      },
    },
  },
})
