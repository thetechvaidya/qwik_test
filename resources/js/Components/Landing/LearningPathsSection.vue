<template>
  <!-- Learning Paths Section -->
  <section class="py-20 bg-gradient-to-br from-indigo-50 via-white to-purple-50 relative overflow-hidden">
    <!-- Background decoration -->
    <div class="absolute inset-0">
      <!-- Geometric shapes -->
      <div class="absolute top-20 left-10 w-32 h-32 bg-gradient-to-br from-indigo-200/30 to-purple-200/30 rounded-full blur-xl"></div>
      <div class="absolute top-40 right-20 w-24 h-24 bg-gradient-to-br from-cyan-200/30 to-blue-200/30 rounded-full blur-xl"></div>
      <div class="absolute bottom-20 left-1/3 w-40 h-40 bg-gradient-to-br from-emerald-200/30 to-green-200/30 rounded-full blur-xl"></div>
      
      <!-- Grid pattern -->
      <div class="absolute inset-0 opacity-5">
        <div class="h-full w-full" style="background-image: radial-gradient(circle at 25px 25px, rgba(99, 102, 241, 0.3) 2px, transparent 0); background-size: 50px 50px;"></div>
      </div>
    </div>

    <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative">
      <!-- Section Header -->
      <div class="text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
          Choose Your <span class="bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent">Learning Path</span>
        </h2>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
          Structured learning journeys designed by experts to take you from beginner to professional, with hands-on projects and real-world applications
        </p>
      </div>

      <!-- Learning Paths Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-16">
        <!-- Beginner Path -->
        <div class="group relative">
          <div class="bg-white rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 overflow-hidden border border-gray-100 hover:border-indigo-200 group-hover:transform group-hover:scale-[1.02]">
            <!-- Header with gradient -->
            <div class="relative h-48 bg-gradient-to-br from-green-400 to-emerald-600 p-8 flex items-end">
              <!-- Background pattern -->
              <div class="absolute inset-0 opacity-20">
                <svg width="100%" height="100%" viewBox="0 0 400 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <circle cx="50" cy="50" r="20" fill="white" opacity="0.1"/>
                  <circle cx="150" cy="80" r="15" fill="white" opacity="0.2"/>
                  <circle cx="250" cy="40" r="25" fill="white" opacity="0.1"/>
                  <circle cx="350" cy="120" r="18" fill="white" opacity="0.15"/>
                  <path d="M50 70 Q100 50 150 80 T250 65 T350 140" stroke="white" stroke-width="2" fill="none" opacity="0.3"/>
                </svg>
              </div>
              
              <!-- Content -->
              <div class="relative z-10">
                <div class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center mb-4">
                  <i class="pi pi-star text-white text-xl"></i>
                </div>
                <h3 class="text-2xl font-bold text-white mb-2">Beginner</h3>
                <p class="text-green-100">Perfect starting point for newcomers</p>
              </div>
            </div>

            <!-- Content -->
            <div class="p-8">
              <div class="flex items-center gap-2 mb-4">
                <span class="px-3 py-1 bg-green-100 text-green-700 text-xs font-medium rounded-full">3-6 months</span>
                <span class="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">No prerequisites</span>
              </div>

              <p class="text-gray-600 mb-6 leading-relaxed">
                Start your learning journey with fundamentals. Build confidence through step-by-step guidance and practical exercises.
              </p>

              <!-- Features -->
              <div class="space-y-3 mb-8">
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-green-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Interactive tutorials</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-green-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Guided practice sessions</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-green-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Community support</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-green-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Beginner-friendly projects</span>
                </div>
              </div>

              <!-- Progress indicator -->
              <div class="mb-6">
                <div class="flex justify-between text-xs text-gray-500 mb-2">
                  <span>Completion Rate</span>
                  <span>92%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div class="bg-gradient-to-r from-green-400 to-emerald-500 h-2 rounded-full" style="width: 92%"></div>
                </div>
              </div>

              <!-- CTA -->
              <Link 
                href="/paths/beginner"
                class="w-full block text-center py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white font-semibold rounded-xl hover:from-green-600 hover:to-emerald-700 transition-all duration-300 transform hover:scale-105"
              >
                Start Beginner Path
              </Link>
            </div>
          </div>
        </div>

        <!-- Intermediate Path -->
        <div class="group relative">
          <div class="bg-white rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 overflow-hidden border border-gray-100 hover:border-indigo-200 group-hover:transform group-hover:scale-[1.02]">
            <!-- Popular badge -->
            <div class="absolute top-4 right-4 z-20 px-3 py-1 bg-indigo-600 text-white text-xs font-bold rounded-full">
              Most Popular
            </div>

            <!-- Header with gradient -->
            <div class="relative h-48 bg-gradient-to-br from-indigo-500 to-purple-600 p-8 flex items-end">
              <!-- Background pattern -->
              <div class="absolute inset-0 opacity-20">
                <svg width="100%" height="100%" viewBox="0 0 400 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <rect x="50" y="40" width="60" height="60" rx="8" fill="white" opacity="0.1"/>
                  <rect x="150" y="60" width="40" height="40" rx="6" fill="white" opacity="0.2"/>
                  <rect x="250" y="30" width="50" height="50" rx="7" fill="white" opacity="0.15"/>
                  <path d="M80 100 L180 80 L280 55 L350 85" stroke="white" stroke-width="3" fill="none" opacity="0.3"/>
                </svg>
              </div>
              
              <!-- Content -->
              <div class="relative z-10">
                <div class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center mb-4">
                  <i class="pi pi-bolt text-white text-xl"></i>
                </div>
                <h3 class="text-2xl font-bold text-white mb-2">Intermediate</h3>
                <p class="text-indigo-100">Accelerate your skills and knowledge</p>
              </div>
            </div>

            <!-- Content -->
            <div class="p-8">
              <div class="flex items-center gap-2 mb-4">
                <span class="px-3 py-1 bg-indigo-100 text-indigo-700 text-xs font-medium rounded-full">6-12 months</span>
                <span class="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">Basic knowledge</span>
              </div>

              <p class="text-gray-600 mb-6 leading-relaxed">
                Build upon your foundation with advanced concepts, real-world projects, and industry best practices.
              </p>

              <!-- Features -->
              <div class="space-y-3 mb-8">
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-indigo-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Advanced techniques</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-indigo-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Real-world projects</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-indigo-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Industry mentorship</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-indigo-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-indigo-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Portfolio development</span>
                </div>
              </div>

              <!-- Progress indicator -->
              <div class="mb-6">
                <div class="flex justify-between text-xs text-gray-500 mb-2">
                  <span>Completion Rate</span>
                  <span>88%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div class="bg-gradient-to-r from-indigo-500 to-purple-500 h-2 rounded-full" style="width: 88%"></div>
                </div>
              </div>

              <!-- CTA -->
              <Link 
                href="/paths/intermediate"
                class="w-full block text-center py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105"
              >
                Start Intermediate Path
              </Link>
            </div>
          </div>
        </div>

        <!-- Advanced Path -->
        <div class="group relative">
          <div class="bg-white rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 overflow-hidden border border-gray-100 hover:border-indigo-200 group-hover:transform group-hover:scale-[1.02]">
            <!-- Header with gradient -->
            <div class="relative h-48 bg-gradient-to-br from-orange-500 to-red-600 p-8 flex items-end">
              <!-- Background pattern -->
              <div class="absolute inset-0 opacity-20">
                <svg width="100%" height="100%" viewBox="0 0 400 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <polygon points="80,40 120,80 80,120 40,80" fill="white" opacity="0.1"/>
                  <polygon points="200,50 240,90 200,130 160,90" fill="white" opacity="0.15"/>
                  <polygon points="320,35 360,75 320,115 280,75" fill="white" opacity="0.1"/>
                  <path d="M80 80 Q150 60 200 90 T320 75" stroke="white" stroke-width="3" fill="none" opacity="0.3"/>
                </svg>
              </div>
              
              <!-- Content -->
              <div class="relative z-10">
                <div class="w-12 h-12 bg-white/20 backdrop-blur-sm rounded-xl flex items-center justify-center mb-4">
                  <i class="pi pi-crown text-white text-xl"></i>
                </div>
                <h3 class="text-2xl font-bold text-white mb-2">Advanced</h3>
                <p class="text-orange-100">Master-level expertise and leadership</p>
              </div>
            </div>

            <!-- Content -->
            <div class="p-8">
              <div class="flex items-center gap-2 mb-4">
                <span class="px-3 py-1 bg-orange-100 text-orange-700 text-xs font-medium rounded-full">12+ months</span>
                <span class="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">Expert level</span>
              </div>

              <p class="text-gray-600 mb-6 leading-relaxed">
                Achieve mastery with cutting-edge topics, leadership training, and specialized industry certifications.
              </p>

              <!-- Features -->
              <div class="space-y-3 mb-8">
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-orange-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-orange-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Cutting-edge technologies</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-orange-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-orange-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Leadership development</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-orange-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-orange-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Expert consultations</span>
                </div>
                <div class="flex items-center gap-3">
                  <div class="w-6 h-6 bg-orange-100 rounded-full flex items-center justify-center">
                    <i class="pi pi-check text-orange-600 text-xs"></i>
                  </div>
                  <span class="text-sm text-gray-700">Industry certifications</span>
                </div>
              </div>

              <!-- Progress indicator -->
              <div class="mb-6">
                <div class="flex justify-between text-xs text-gray-500 mb-2">
                  <span>Completion Rate</span>
                  <span>85%</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div class="bg-gradient-to-r from-orange-500 to-red-500 h-2 rounded-full" style="width: 85%"></div>
                </div>
              </div>

              <!-- CTA -->
              <Link 
                href="/paths/advanced"
                class="w-full block text-center py-3 bg-gradient-to-r from-orange-500 to-red-600 text-white font-semibold rounded-xl hover:from-orange-600 hover:to-red-700 transition-all duration-300 transform hover:scale-105"
              >
                Start Advanced Path
              </Link>
            </div>
          </div>
        </div>
      </div>

      <!-- Path Comparison Table -->
      <div class="bg-white rounded-3xl shadow-xl border border-gray-100 overflow-hidden mb-16">
        <div class="bg-gradient-to-r from-slate-800 to-slate-900 p-8 text-center">
          <h3 class="text-2xl font-bold text-white mb-2">Compare Learning Paths</h3>
          <p class="text-slate-300">Choose the path that best fits your current skill level and goals</p>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full">
            <thead class="bg-gray-50">
              <tr>
                <th class="px-6 py-4 text-left text-sm font-semibold text-gray-900">Feature</th>
                <th class="px-6 py-4 text-center text-sm font-semibold text-green-700">Beginner</th>
                <th class="px-6 py-4 text-center text-sm font-semibold text-indigo-700">Intermediate</th>
                <th class="px-6 py-4 text-center text-sm font-semibold text-orange-700">Advanced</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-200">
              <tr>
                <td class="px-6 py-4 text-sm font-medium text-gray-900">Duration</td>
                <td class="px-6 py-4 text-sm text-center text-gray-600">3-6 months</td>
                <td class="px-6 py-4 text-sm text-center text-gray-600">6-12 months</td>
                <td class="px-6 py-4 text-sm text-center text-gray-600">12+ months</td>
              </tr>
              <tr class="bg-gray-50">
                <td class="px-6 py-4 text-sm font-medium text-gray-900">Prerequisites</td>
                <td class="px-6 py-4 text-sm text-center text-gray-600">None</td>
                <td class="px-6 py-4 text-sm text-center text-gray-600">Basic knowledge</td>
                <td class="px-6 py-4 text-sm text-center text-gray-600">Expert level</td>
              </tr>
              <tr>
                <td class="px-6 py-4 text-sm font-medium text-gray-900">Projects</td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-green-600"></i>
                </td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-indigo-600"></i>
                </td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-orange-600"></i>
                </td>
              </tr>
              <tr class="bg-gray-50">
                <td class="px-6 py-4 text-sm font-medium text-gray-900">Mentorship</td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-minus text-gray-400"></i>
                </td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-indigo-600"></i>
                </td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-orange-600"></i>
                </td>
              </tr>
              <tr>
                <td class="px-6 py-4 text-sm font-medium text-gray-900">Certification</td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-green-600"></i>
                </td>
                <td class="px-6 py-4 text-center">
                  <i class="pi pi-check text-indigo-600"></i>
                </td>
                <td class="px-6 py-4 text-center">
                  <span class="text-xs font-semibold text-orange-600">Industry</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Custom Path CTA -->
      <div class="text-center">
        <div class="inline-flex flex-col lg:flex-row items-center gap-8 bg-gradient-to-r from-slate-50 to-indigo-50 border border-indigo-100 rounded-3xl p-8 lg:p-12">
          <div class="flex items-center gap-6">
            <div class="w-20 h-20 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl flex items-center justify-center">
              <i class="pi pi-cog text-white text-3xl"></i>
            </div>
            <div class="text-left">
              <h3 class="text-2xl font-bold text-gray-900 mb-2">Need a Custom Path?</h3>
              <p class="text-gray-600 max-w-md">
                We can create a personalized learning journey based on your specific goals, timeline, and experience level.
              </p>
            </div>
          </div>
          <div class="flex flex-col sm:flex-row gap-4">
            <Link
              href="/consultation"
              class="px-8 py-4 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl"
            >
              Get Consultation
            </Link>
            <Link
              href="/paths"
              class="px-8 py-4 bg-white border-2 border-indigo-200 text-indigo-700 font-semibold rounded-xl hover:border-indigo-400 hover:bg-indigo-50 transition-all duration-300"
            >
              View All Paths
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
/* Card hover animations */
.group:hover .bg-white {
  transform: translateY(-8px);
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

/* Progress bar animations */
.bg-gradient-to-r.from-green-400.to-emerald-500,
.bg-gradient-to-r.from-indigo-500.to-purple-500,
.bg-gradient-to-r.from-orange-500.to-red-500 {
  animation: progress-fill 2s ease-out;
}

@keyframes progress-fill {
  from {
    width: 0%;
  }
  to {
    width: var(--progress-width, 100%);
  }
}

/* Background pattern animations */
.absolute.inset-0 svg {
  animation: pattern-float 20s ease-in-out infinite;
}

@keyframes pattern-float {
  0%, 100% {
    transform: scale(1) rotate(0deg);
    opacity: 0.2;
  }
  50% {
    transform: scale(1.05) rotate(2deg);
    opacity: 0.3;
  }
}

/* Button hover effects */
[class*="transform"][class*="hover:scale-105"]:hover {
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Table row hover */
tbody tr:hover {
  background-color: rgba(99, 102, 241, 0.05);
}

/* Mobile responsiveness */
@media (max-width: 1024px) {
  [class*="lg:flex-row"] {
    flex-direction: column;
  }
  
  [class*="lg:p-12"] {
    padding: 2rem;
  }
}

/* Badge animation */
.absolute.top-4.right-4 {
  animation: badge-pulse 2s ease-in-out infinite;
}

@keyframes badge-pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

/* Icon hover effects */
.w-12.h-12:hover,
.w-20.h-20:hover {
  transform: scale(1.1) rotate(5deg);
  transition: transform 0.3s ease;
}
</style>