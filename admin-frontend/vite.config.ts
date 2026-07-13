import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  // 生产环境自动移除 console/debugger
  esbuild: {
    drop: process.env.NODE_ENV === 'production' ? ['console', 'debugger'] : [],
  },
  build: {
    rollupOptions: {
      output: {
        manualChunks(id: string) {
          if (id.includes('node_modules/element-plus') || id.includes('@element-plus/icons-vue')) return 'vendor-element-plus'
          if (id.includes('node_modules/axios')) return 'vendor-axios'
          if (id.includes('node_modules/vue') || id.includes('node_modules/vue-router') || id.includes('node_modules/pinia')) return 'vendor-vue'
        },
      },
    },
  },
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
