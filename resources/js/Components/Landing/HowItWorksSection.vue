<template>
  <!-- How It Works Section -->
  <section class="py-20 bg-slate-900 relative overflow-hidden">
    <!-- Animated Background Pattern -->
    <div class="absolute inset-0">
      <div class="absolute top-0 left-0 w-full h-full">
        <!-- Circuit board pattern -->
        <svg class="absolute inset-0 w-full h-full opacity-10" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <pattern id="circuit" x="0" y="0" width="100" height="100" patternUnits="userSpaceOnUse">
              <circle cx="20" cy="20" r="2" fill="currentColor"/>
              <circle cx="80" cy="80" r="2" fill="currentColor"/>
              <line x1="20" y1="20" x2="80" y2="20" stroke="currentColor" stroke-width="0.5"/>
              <line x1="80" y1="20" x2="80" y2="80" stroke="currentColor" stroke-width="0.5"/>
              <line x1="20" y1="60" x2="60" y2="60" stroke="currentColor" stroke-width="0.5"/>
              <line x1="60" y1="20" x2="60" y2="60" stroke="currentColor" stroke-width="0.5"/>
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#circuit)" class="text-indigo-400"/>
        </svg>
      </div>
      <!-- Gradient overlays -->
      <div class="absolute top-1/4 left-0 w-96 h-96 bg-gradient-to-r from-indigo-600/20 to-purple-600/20 rounded-full blur-3xl"></div>
      <div class="absolute bottom-1/4 right-0 w-96 h-96 bg-gradient-to-l from-cyan-600/20 to-blue-600/20 rounded-full blur-3xl"></div>
    </div>

    <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative">
      <!-- Section Header -->
      <div class="text-center mb-20">
        <h2 class="text-4xl md:text-5xl font-bold text-white mb-6">
          How <span class="bg-gradient-to-r from-indigo-400 to-cyan-400 bg-clip-text text-transparent">QwikTest</span> Works
        </h2>
        <p class="text-xl text-gray-300 max-w-3xl mx-auto leading-relaxed">
          From registration to certification, experience a seamless learning journey designed for success
        </p>
      </div>

      <!-- Process Steps -->
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-8 mb-16">
        <!-- Step 1: Sign Up -->
        <div class="relative group">
          <!-- Connection Line -->
          <div class="hidden lg:block absolute top-16 left-full w-full h-0.5 bg-gradient-to-r from-indigo-500 to-transparent -translate-x-4 z-0"></div>
          
          <div class="relative bg-slate-800/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-8 hover:bg-slate-800/70 transition-all duration-500 group-hover:transform group-hover:scale-105 group-hover:border-indigo-500/50">
            <!-- Step Number -->
            <div class="absolute -top-4 left-8 w-8 h-8 bg-gradient-to-r from-indigo-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
              1
            </div>
            
            <!-- Icon -->
            <div class="w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center mb-6 group-hover:shadow-lg group-hover:shadow-indigo-500/25 transition-all duration-300">
              <i class="pi pi-user-plus text-white text-2xl"></i>
            </div>
            
            <!-- Content -->
            <h3 class="text-xl font-bold text-white mb-3">Quick Registration</h3>
            <p class="text-gray-300 text-sm leading-relaxed mb-4">
              Create your account in seconds with email or social login. No complex forms, just simple onboarding.
            </p>
            
            <!-- Features -->
            <ul class="space-y-2 text-xs text-gray-400">
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Email or social signup
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Instant account activation
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Profile customization
              </li>
            </ul>
          </div>
        </div>

        <!-- Step 2: Choose Course -->
        <div class="relative group">
          <!-- Connection Line -->
          <div class="hidden lg:block absolute top-16 left-full w-full h-0.5 bg-gradient-to-r from-purple-500 to-transparent -translate-x-4 z-0"></div>
          
          <div class="relative bg-slate-800/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-8 hover:bg-slate-800/70 transition-all duration-500 group-hover:transform group-hover:scale-105 group-hover:border-purple-500/50">
            <!-- Step Number -->
            <div class="absolute -top-4 left-8 w-8 h-8 bg-gradient-to-r from-purple-500 to-pink-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
              2
            </div>
            
            <!-- Icon -->
            <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-pink-600 rounded-2xl flex items-center justify-center mb-6 group-hover:shadow-lg group-hover:shadow-purple-500/25 transition-all duration-300">
              <i class="pi pi-book text-white text-2xl"></i>
            </div>
            
            <!-- Content -->
            <h3 class="text-xl font-bold text-white mb-3">Select Learning Path</h3>
            <p class="text-gray-300 text-sm leading-relaxed mb-4">
              Browse our curated courses and choose the perfect learning path that matches your goals and skill level.
            </p>
            
            <!-- Features -->
            <ul class="space-y-2 text-xs text-gray-400">
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Skill assessment
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Personalized recommendations
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Course previews
              </li>
            </ul>
          </div>
        </div>

        <!-- Step 3: Learn & Practice -->
        <div class="relative group">
          <!-- Connection Line -->
          <div class="hidden lg:block absolute top-16 left-full w-full h-0.5 bg-gradient-to-r from-cyan-500 to-transparent -translate-x-4 z-0"></div>
          
          <div class="relative bg-slate-800/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-8 hover:bg-slate-800/70 transition-all duration-500 group-hover:transform group-hover:scale-105 group-hover:border-cyan-500/50">
            <!-- Step Number -->
            <div class="absolute -top-4 left-8 w-8 h-8 bg-gradient-to-r from-cyan-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
              3
            </div>
            
            <!-- Icon -->
            <div class="w-16 h-16 bg-gradient-to-br from-cyan-500 to-blue-600 rounded-2xl flex items-center justify-center mb-6 group-hover:shadow-lg group-hover:shadow-cyan-500/25 transition-all duration-300">
              <i class="pi pi-desktop text-white text-2xl"></i>
            </div>
            
            <!-- Content -->
            <h3 class="text-xl font-bold text-white mb-3">Interactive Learning</h3>
            <p class="text-gray-300 text-sm leading-relaxed mb-4">
              Engage with interactive content, practice with real-world scenarios, and track your progress in real-time.
            </p>
            
            <!-- Features -->
            <ul class="space-y-2 text-xs text-gray-400">
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Interactive modules
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Practice exercises
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Progress tracking
              </li>
            </ul>
          </div>
        </div>

        <!-- Step 4: Get Certified -->
        <div class="relative group">
          <div class="relative bg-slate-800/50 backdrop-blur-sm border border-slate-700/50 rounded-2xl p-8 hover:bg-slate-800/70 transition-all duration-500 group-hover:transform group-hover:scale-105 group-hover:border-emerald-500/50">
            <!-- Step Number -->
            <div class="absolute -top-4 left-8 w-8 h-8 bg-gradient-to-r from-emerald-500 to-green-600 rounded-full flex items-center justify-center text-white font-bold text-sm">
              4
            </div>
            
            <!-- Icon -->
            <div class="w-16 h-16 bg-gradient-to-br from-emerald-500 to-green-600 rounded-2xl flex items-center justify-center mb-6 group-hover:shadow-lg group-hover:shadow-emerald-500/25 transition-all duration-300">
              <i class="pi pi-trophy text-white text-2xl"></i>
            </div>
            
            <!-- Content -->
            <h3 class="text-xl font-bold text-white mb-3">Earn Certification</h3>
            <p class="text-gray-300 text-sm leading-relaxed mb-4">
              Complete assessments, demonstrate your skills, and receive industry-recognized certificates to boost your career.
            </p>
            
            <!-- Features -->
            <ul class="space-y-2 text-xs text-gray-400">
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Final assessments
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                Digital certificates
              </li>
              <li class="flex items-center gap-2">
                <i class="pi pi-check text-green-400 text-xs"></i>
                LinkedIn integration
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Stats Section -->
      <div class="bg-slate-800/30 backdrop-blur-sm border border-slate-700/30 rounded-3xl p-12 mb-16">
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8 text-center">
          <div class="group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-indigo-400 to-cyan-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              50K+
            </div>
            <div class="text-gray-300 text-sm font-medium">Students Enrolled</div>
          </div>
          <div class="group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              95%
            </div>
            <div class="text-gray-300 text-sm font-medium">Success Rate</div>
          </div>
          <div class="group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-cyan-400 to-blue-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              500+
            </div>
            <div class="text-gray-300 text-sm font-medium">Courses Available</div>
          </div>
          <div class="group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-emerald-400 to-green-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              24/7
            </div>
            <div class="text-gray-300 text-sm font-medium">Support Available</div>
          </div>
        </div>
      </div>

      <!-- Call to Action -->
      <div class="text-center">
        <div class="inline-flex flex-col sm:flex-row items-center gap-6 bg-gradient-to-r from-slate-800/50 to-slate-700/50 backdrop-blur-sm border border-slate-600/30 rounded-2xl p-8">
          <div class="flex items-center gap-4">
            <div class="w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full flex items-center justify-center">
              <i class="pi pi-bolt text-white text-2xl"></i>
            </div>
            <div class="text-left">
              <h3 class="text-xl font-bold text-white mb-1">Ready to get started?</h3>
              <p class="text-gray-300">Join thousands of learners already on their journey</p>
            </div>
          </div>
          <div class="flex flex-col sm:flex-row gap-3">
            <Link
              href="/register"
              class="px-8 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
            >
              Start Learning
            </Link>
            <Link
              href="/courses"
              class="px-8 py-3 bg-transparent border-2 border-slate-600 text-gray-300 font-semibold rounded-xl hover:border-indigo-500 hover:text-white transition-all duration-300"
            >
              Browse Courses
            </Link>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
</script>

<style scoped>
/* Animated connection lines */
.group:hover + .group::before {
  animation: pulse-line 2s ease-in-out infinite;
}

/* Floating animation for background elements */
@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(0deg);
  }
  50% {
    transform: translateY(-20px) rotate(5deg);
  }
}

/* Step cards hover effects */
.group:hover .w-16.h-16 {
  transform: scale(1.1) rotate(5deg);
}

/* Connection line animation */
@keyframes pulse-line {
  0%, 100% {
    opacity: 0.3;
  }
  50% {
    opacity: 1;
  }
}

/* Mobile responsiveness */
@media (max-width: 1024px) {
  [class*="lg:block"] {
    display: none !important;
  }
}

/* Background circuit animation */
.absolute.inset-0 svg {
  animation: circuit-glow 10s ease-in-out infinite;
}

@keyframes circuit-glow {
  0%, 100% {
    opacity: 0.1;
  }
  50% {
    opacity: 0.2;
  }
}

/* Stats number animation on hover */
.group:hover .text-4xl,
.group:hover .text-5xl {
  animation: bounce-number 0.6s ease-in-out;
}

@keyframes bounce-number {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.15);
  }
}
</style>