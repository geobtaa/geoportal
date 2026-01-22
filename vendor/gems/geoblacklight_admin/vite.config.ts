import { resolve } from 'path'
import { defineConfig } from 'vite'
import { exec } from 'child_process'

export default defineConfig({
  build: {
    manifest: true,
    minify: true,
    reportCompressedSize: true,
    lib: {
      entry: resolve(__dirname, 'app/javascript/index.js'),
      name: '@geoblacklight/admin',
      fileName: 'frontend'
    },
    rollupOptions: {
      external: [],
      output: {
        // Exclude specific directories from the build
        assetFileNames: (assetInfo) => {
          const name = assetInfo.name || '';
          // Skip assets from these directories
          if (name.includes('dist/') || 
              name.includes('derivatives/') || 
              name.includes('uploads/')) {
            return 'ignored';
          }
          return name;
        }
      }
    }
  },
  // Exclude directories from being processed by Vite
  publicDir: false,
  "plugins": [
    {
      name: 'filter-unwanted-assets',
      generateBundle(options, bundle) {
        // Remove any assets from unwanted directories
        Object.keys(bundle).forEach(fileName => {
          if (fileName.includes('dist/') || 
              fileName.includes('derivatives/') || 
              fileName.includes('uploads/')) {
            delete bundle[fileName];
          }
        });
      }
    },
    {
      name: 'clobber internal test app vite files and cache',
      buildEnd: async() => {
        exec("cd .internal_test_app && bundle exec vite clobber")
      }
    }
  ]
})
