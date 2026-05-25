import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    host: true,
    proxy: {
      '/api': process.env.BACKEND_URL ?? 'http://localhost:3000',
    },
  },
})
