<template>
  <!-- Image Gallery Section -->
  <section class="py-20 bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 relative overflow-hidden">
    <!-- Background Decoration -->
    <div class="absolute inset-0">
      <div class="absolute top-0 left-1/4 w-72 h-72 bg-gradient-to-br from-purple-400/20 to-pink-400/20 rounded-full blur-3xl"></div>
      <div class="absolute bottom-0 right-1/4 w-96 h-96 bg-gradient-to-br from-blue-400/20 to-cyan-400/20 rounded-full blur-3xl"></div>
    </div>

    <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative">
      <!-- Section Header -->
      <div class="text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
          Experience <span class="bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">Modern Learning</span>
        </h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
          Discover our intuitive interface, comprehensive features, and engaging learning environment through these snapshots
        </p>
      </div>

      <!-- Main Gallery Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
        <!-- Featured Large Image -->
        <div class="md:col-span-2 lg:col-span-2 group cursor-pointer">
          <div class="relative overflow-hidden rounded-2xl bg-white shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-[1.02]">
            <div class="aspect-[16/10] bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center">
              <!-- Dashboard Preview SVG -->
              <svg class="w-full h-full p-8" viewBox="0 0 800 500" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- Dashboard Frame -->
                <rect x="40" y="40" width="720" height="420" rx="12" fill="white" stroke="rgba(255,255,255,0.2)" stroke-width="2"/>
                
                <!-- Header Bar -->
                <rect x="40" y="40" width="720" height="60" rx="12" fill="rgba(255,255,255,0.1)"/>
                <circle cx="80" cy="70" r="15" fill="rgba(255,255,255,0.3)"/>
                <rect x="110" y="62" width="100" height="16" rx="8" fill="rgba(255,255,255,0.3)"/>
                
                <!-- Navigation -->
                <rect x="60" y="120" width="140" height="320" rx="8" fill="rgba(255,255,255,0.1)"/>
                <rect x="80" y="140" width="100" height="12" rx="6" fill="rgba(255,255,255,0.3)"/>
                <rect x="80" y="165" width="80" height="12" rx="6" fill="rgba(255,255,255,0.2)"/>
                <rect x="80" y="190" width="90" height="12" rx="6" fill="rgba(255,255,255,0.2)"/>
                
                <!-- Main Content Cards -->
                <rect x="220" y="120" width="160" height="120" rx="8" fill="rgba(255,255,255,0.15)"/>
                <rect x="400" y="120" width="160" height="120" rx="8" fill="rgba(255,255,255,0.15)"/>
                <rect x="580" y="120" width="160" height="120" rx="8" fill="rgba(255,255,255,0.15)"/>
                
                <!-- Charts/Analytics -->
                <rect x="220" y="260" width="520" height="180" rx="8" fill="rgba(255,255,255,0.1)"/>
                
                <!-- Chart bars -->
                <rect x="260" y="360" width="20" height="60" fill="rgba(255,255,255,0.4)"/>
                <rect x="290" y="340" width="20" height="80" fill="rgba(255,255,255,0.5)"/>
                <rect x="320" y="320" width="20" height="100" fill="rgba(255,255,255,0.6)"/>
                <rect x="350" y="380" width="20" height="40" fill="rgba(255,255,255,0.3)"/>
              </svg>
            </div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-6 text-white">
              <h3 class="text-2xl font-bold mb-2">Interactive Dashboard</h3>
              <p class="text-white/90">Comprehensive analytics and progress tracking in real-time</p>
            </div>
            <!-- Play button overlay -->
            <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
              <div class="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center">
                <i class="pi pi-play text-white text-2xl ml-1"></i>
              </div>
            </div>
          </div>
        </div>

        <!-- Smaller Feature Images -->
        <div class="space-y-8">
          <!-- Mobile App Preview -->
          <div class="group cursor-pointer">
            <div class="relative overflow-hidden rounded-xl bg-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
              <div class="aspect-[4/3] bg-gradient-to-br from-emerald-500 to-teal-600 flex items-center justify-center p-6">
                <!-- Mobile Phone SVG -->
                <svg class="w-24 h-40" viewBox="0 0 120 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <rect x="10" y="10" width="100" height="180" rx="20" fill="white" stroke="rgba(255,255,255,0.3)" stroke-width="2"/>
                  <rect x="20" y="30" width="80" height="140" rx="8" fill="rgba(255,255,255,0.9)"/>
                  <rect x="30" y="40" width="60" height="8" rx="4" fill="rgba(16,185,129,0.3)"/>
                  <rect x="30" y="55" width="40" height="6" rx="3" fill="rgba(16,185,129,0.2)"/>
                  <rect x="30" y="70" width="60" height="40" rx="6" fill="rgba(16,185,129,0.1)"/>
                  <circle cx="60" cy="180" r="8" fill="rgba(255,255,255,0.5)"/>
                </svg>
              </div>
              <div class="absolute bottom-0 left-0 right-0 p-4 bg-gradient-to-t from-black/60 to-transparent">
                <h4 class="text-white font-semibold text-sm">Mobile Learning</h4>
              </div>
            </div>
          </div>

          <!-- Quiz Interface -->
          <div class="group cursor-pointer">
            <div class="relative overflow-hidden rounded-xl bg-white shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105">
              <div class="aspect-[4/3] bg-gradient-to-br from-orange-500 to-red-500 flex items-center justify-center p-6">
                <!-- Quiz Interface SVG -->
                <svg class="w-full h-full" viewBox="0 0 200 150" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <rect x="20" y="20" width="160" height="110" rx="12" fill="white" stroke="rgba(255,255,255,0.2)" stroke-width="2"/>
                  <rect x="30" y="30" width="140" height="20" rx="4" fill="rgba(255,255,255,0.3)"/>
                  <circle cx="45" cy="70" r="8" fill="rgba(255,255,255,0.2)"/>
                  <rect x="60" y="65" width="100" height="10" rx="2" fill="rgba(255,255,255,0.3)"/>
                  <circle cx="45" cy="90" r="8" fill="rgba(255,255,255,0.4)"/>
                  <rect x="60" y="85" width="80" height="10" rx="2" fill="rgba(255,255,255,0.3)"/>
                  <circle cx="45" cy="110" r="8" fill="rgba(255,255,255,0.2)"/>
                  <rect x="60" y="105" width="90" height="10" rx="2" fill="rgba(255,255,255,0.3)"/>
                </svg>
              </div>
              <div class="absolute bottom-0 left-0 right-0 p-4 bg-gradient-to-t from-black/60 to-transparent">
                <h4 class="text-white font-semibold text-sm">Smart Quizzes</h4>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Secondary Gallery Row -->
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
        <!-- Analytics Card -->
        <div class="group cursor-pointer">
          <div class="relative overflow-hidden rounded-xl bg-white shadow-md hover:shadow-lg transition-all duration-300">
            <div class="aspect-square bg-gradient-to-br from-violet-500 to-purple-600 flex items-center justify-center">
              <i class="pi pi-chart-line text-white text-3xl"></i>
            </div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-3">
              <h5 class="text-white font-medium text-xs">Analytics</h5>
            </div>
          </div>
        </div>

        <!-- Certificates Card -->
        <div class="group cursor-pointer">
          <div class="relative overflow-hidden rounded-xl bg-white shadow-md hover:shadow-lg transition-all duration-300">
            <div class="aspect-square bg-gradient-to-br from-amber-500 to-orange-500 flex items-center justify-center">
              <i class="pi pi-trophy text-white text-3xl"></i>
            </div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-3">
              <h5 class="text-white font-medium text-xs">Certificates</h5>
            </div>
          </div>
        </div>

        <!-- Community Card -->
        <div class="group cursor-pointer">
          <div class="relative overflow-hidden rounded-xl bg-white shadow-md hover:shadow-lg transition-all duration-300">
            <div class="aspect-square bg-gradient-to-br from-green-500 to-emerald-600 flex items-center justify-center">
              <i class="pi pi-users text-white text-3xl"></i>
            </div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-3">
              <h5 class="text-white font-medium text-xs">Community</h5>
            </div>
          </div>
        </div>

        <!-- Support Card -->
        <div class="group cursor-pointer">
          <div class="relative overflow-hidden rounded-xl bg-white shadow-md hover:shadow-lg transition-all duration-300">
            <div class="aspect-square bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center">
              <i class="pi pi-headphones text-white text-3xl"></i>
            </div>
            <div class="absolute inset-0 bg-gradient-to-t from-black/40 to-transparent"></div>
            <div class="absolute bottom-0 left-0 right-0 p-3">
              <h5 class="text-white font-medium text-xs">24/7 Support</h5>
            </div>
          </div>
        </div>
      </div>

      <!-- Call to Action -->
      <div class="text-center mt-16">
        <div class="inline-flex items-center gap-4 bg-white/70 backdrop-blur-sm border border-white/20 rounded-2xl p-8 shadow-xl">
          <div class="w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-eye text-white text-2xl"></i>
          </div>
          <div class="text-left">
            <h3 class="text-xl font-bold text-gray-900 mb-1">See it in action</h3>
            <p class="text-gray-600">Experience our platform with a personalized demo</p>
          </div>
          <Link
            href="/demo"
            class="px-8 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
          >
            Request Demo
          </Link>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
</script>

<style scoped>
/* Animation for gallery items */
.group:hover svg {
  transform: scale(1.05);
  transition: transform 0.3s ease;
}

/* Parallax effect for background */
@media (min-width: 768px) {
  .absolute.inset-0 > div {
    animation: float 20s ease-in-out infinite;
  }
  
  .absolute.inset-0 > div:nth-child(2) {
    animation-delay: -10s;
  }
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) translateX(0px);
  }
  25% {
    transform: translateY(-20px) translateX(10px);
  }
  50% {
    transform: translateY(0px) translateX(-10px);
  }
  75% {
    transform: translateY(20px) translateX(5px);
  }
}

/* Hover effects */
.group:hover [class*="aspect-square"],
.group:hover [class*="aspect-[4/3]"],
.group:hover [class*="aspect-[16/10]"] {
  background-size: 110%;
  transition: background-size 0.5s ease;
}

/* Mobile responsiveness */
@media (max-width: 768px) {
  [class*="md:col-span-2"] {
    grid-column: span 1;
  }
  
  [class*="lg:col-span-2"] {
    grid-column: span 1;
  }
}
</style>