import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vite.dev/config/
export default defineConfig({
  plugins: [react({
    // Fast Refresh optimization
    fastRefresh: true,
    // Babel optimization for production
    babel: {
      compact: true,
    }
  })],
  
  // Build optimizations
  build: {
    // Enable chunk splitting for better caching
    rollupOptions: {
      output: {
        manualChunks: {
          'react-vendor': ['react', 'react-dom'],
        }
      }
    },
    // Increase chunk size warning limit (base64 images can be large)
    chunkSizeWarningLimit: 1000,
    // Optimize minification
    minify: 'terser',
    terserOptions: {
      compress: {
        drop_console: true, // Remove console.logs in production
        drop_debugger: true,
        pure_funcs: ['console.log', 'console.info']
      }
    }
  },
  
  // Dev server optimizations
  server: {
    // Enable HMR (Hot Module Replacement) optimizations
    hmr: true,
    // Faster file watching
    watch: {
      usePolling: false,
    }
  },
  
  // Dependency optimization
  optimizeDeps: {
    include: ['react', 'react-dom'],
    // Force re-optimization on config change
    force: false
  }
})
