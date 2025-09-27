<template>
  <div class="logo-showcase bg-white dark:bg-gray-900 py-16">
    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
      <!-- Header -->
      <div class="text-center mb-12">
        <h2 class="text-3xl font-bold text-gray-900 dark:text-white mb-4">
          QwikTest Brand Identity
        </h2>
        <p class="text-lg text-gray-600 dark:text-gray-300">
          Our modern logo system adapts to any context
        </p>
      </div>

      <!-- Logo Variations Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
        
        <!-- Light Theme Full Logo -->
        <div class="bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-lg border border-gray-200 dark:border-gray-700">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Full Logo - Light Theme</h3>
          <div class="flex items-center justify-center h-32 bg-gray-50 dark:bg-gray-700 rounded-lg">
            <QwikTestLogo :width="240" :height="72" variant="light" />
          </div>
        </div>

        <!-- Dark Theme Full Logo -->
        <div class="bg-gray-900 p-8 rounded-2xl shadow-lg border border-gray-700">
          <h3 class="text-lg font-semibold text-white mb-4">Full Logo - Dark Theme</h3>
          <div class="flex items-center justify-center h-32 bg-gray-800 rounded-lg">
            <QwikTestLogo :width="240" :height="72" variant="dark" />
          </div>
        </div>

        <!-- Icon Only - Light -->
        <div class="bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-lg border border-gray-200 dark:border-gray-700">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white mb-4">Icon - Light Theme</h3>
          <div class="flex items-center justify-center h-32 bg-gray-50 dark:bg-gray-700 rounded-lg">
            <QwikTestIcon :size="80" variant="light" />
          </div>
        </div>

        <!-- Icon Only - Dark -->
        <div class="bg-gray-900 p-8 rounded-2xl shadow-lg border border-gray-700">
          <h3 class="text-lg font-semibold text-white mb-4">Icon - Dark Theme</h3>
          <div class="flex items-center justify-center h-32 bg-gray-800 rounded-lg">
            <QwikTestIcon :size="80" variant="dark" />
          </div>
        </div>
      </div>

      <!-- Size Variations -->
      <div class="bg-gradient-to-r from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-700 p-8 rounded-2xl shadow-lg mb-12">
        <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-6 text-center">Size Variations</h3>
        <div class="flex items-center justify-center space-x-8 flex-wrap gap-6">
          <!-- Small -->
          <div class="text-center">
            <QwikTestLogo :width="120" :height="36" variant="light" class="mb-2" />
            <p class="text-sm text-gray-600 dark:text-gray-300">Small (120×36)</p>
          </div>
          
          <!-- Medium -->
          <div class="text-center">
            <QwikTestLogo :width="200" :height="60" variant="light" class="mb-2" />
            <p class="text-sm text-gray-600 dark:text-gray-300">Medium (200×60)</p>
          </div>
          
          <!-- Large -->
          <div class="text-center">
            <QwikTestLogo :width="280" :height="84" variant="light" class="mb-2" />
            <p class="text-sm text-gray-600 dark:text-gray-300">Large (280×84)</p>
          </div>
        </div>
      </div>

      <!-- Usage Guidelines -->
      <div class="bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-lg border border-gray-200 dark:border-gray-700">
        <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-6">Usage Guidelines</h3>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          
          <!-- Do's -->
          <div>
            <h4 class="text-lg font-medium text-green-600 dark:text-green-400 mb-4 flex items-center">
              <i class="pi pi-check-circle mr-2"></i>
              Best Practices
            </h4>
            <ul class="space-y-2 text-gray-600 dark:text-gray-300">
              <li class="flex items-start">
                <i class="pi pi-check text-green-500 mr-2 mt-1 text-sm"></i>
                Use appropriate variant for theme (light/dark)
              </li>
              <li class="flex items-start">
                <i class="pi pi-check text-green-500 mr-2 mt-1 text-sm"></i>
                Maintain aspect ratio when scaling
              </li>
              <li class="flex items-start">
                <i class="pi pi-check text-green-500 mr-2 mt-1 text-sm"></i>
                Use icon version for small spaces (32px or less)
              </li>
              <li class="flex items-start">
                <i class="pi pi-check text-green-500 mr-2 mt-1 text-sm"></i>
                Ensure sufficient contrast with background
              </li>
            </ul>
          </div>

          <!-- Don'ts -->
          <div>
            <h4 class="text-lg font-medium text-red-600 dark:text-red-400 mb-4 flex items-center">
              <i class="pi pi-times-circle mr-2"></i>
              Avoid These
            </h4>
            <ul class="space-y-2 text-gray-600 dark:text-gray-300">
              <li class="flex items-start">
                <i class="pi pi-times text-red-500 mr-2 mt-1 text-sm"></i>
                Don't stretch or distort the logo
              </li>
              <li class="flex items-start">
                <i class="pi pi-times text-red-500 mr-2 mt-1 text-sm"></i>
                Don't use on low-contrast backgrounds
              </li>
              <li class="flex items-start">
                <i class="pi pi-times text-red-500 mr-2 mt-1 text-sm"></i>
                Don't modify colors or elements
              </li>
              <li class="flex items-start">
                <i class="pi pi-times text-red-500 mr-2 mt-1 text-sm"></i>
                Don't use below minimum size requirements
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Color Palette -->
      <div class="mt-12 bg-white dark:bg-gray-800 p-8 rounded-2xl shadow-lg border border-gray-200 dark:border-gray-700">
        <h3 class="text-xl font-semibold text-gray-900 dark:text-white mb-6">Brand Colors</h3>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          
          <div class="text-center">
            <div class="w-full h-16 rounded-lg bg-gradient-to-r from-indigo-600 to-purple-600 mb-2"></div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Primary Gradient</p>
            <p class="text-xs text-gray-600 dark:text-gray-300">#4F46E5 → #7C3AED</p>
          </div>
          
          <div class="text-center">
            <div class="w-full h-16 rounded-lg bg-gradient-to-r from-purple-600 to-pink-600 mb-2"></div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Secondary Gradient</p>
            <p class="text-xs text-gray-600 dark:text-gray-300">#7C3AED → #EC4899</p>
          </div>
          
          <div class="text-center">
            <div class="w-full h-16 rounded-lg bg-yellow-400 mb-2"></div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Lightning</p>
            <p class="text-xs text-gray-600 dark:text-gray-300">#FCD34D</p>
          </div>
          
          <div class="text-center">
            <div class="w-full h-16 rounded-lg bg-white border border-gray-300 mb-2 flex items-center justify-center">
              <span class="text-gray-400 text-xs">Text</span>
            </div>
            <p class="text-sm font-medium text-gray-900 dark:text-white">Text</p>
            <p class="text-xs text-gray-600 dark:text-gray-300">#FFFFFF</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import QwikTestLogo from '@/Components/Icons/QwikTestLogo.vue'
import QwikTestIcon from '@/Components/Icons/QwikTestIcon.vue'
</script>

<style scoped>
.logo-showcase {
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
}

.dark .logo-showcase {
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
}
</style>