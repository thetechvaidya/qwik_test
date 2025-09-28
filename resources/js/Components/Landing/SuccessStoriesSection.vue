<template>
  <!-- Success Stories Section -->
  <section class="py-20 bg-slate-900 relative overflow-hidden">
    <!-- Background elements -->
    <div class="absolute inset-0">
      <!-- Animated gradient blobs -->
      <div class="absolute top-0 left-1/4 w-96 h-96 bg-gradient-to-r from-indigo-600/20 to-purple-600/20 rounded-full blur-3xl animate-blob"></div>
      <div class="absolute top-1/2 right-1/4 w-96 h-96 bg-gradient-to-r from-cyan-600/20 to-blue-600/20 rounded-full blur-3xl animate-blob animation-delay-2000"></div>
      <div class="absolute bottom-0 left-1/2 w-96 h-96 bg-gradient-to-r from-emerald-600/20 to-green-600/20 rounded-full blur-3xl animate-blob animation-delay-4000"></div>
      
      <!-- Stars pattern -->
      <div class="absolute inset-0 opacity-30">
        <div class="absolute top-20 left-10 w-1 h-1 bg-white rounded-full animate-twinkle"></div>
        <div class="absolute top-40 left-1/3 w-1 h-1 bg-indigo-300 rounded-full animate-twinkle animation-delay-1000"></div>
        <div class="absolute top-60 right-20 w-1 h-1 bg-purple-300 rounded-full animate-twinkle animation-delay-2000"></div>
        <div class="absolute bottom-40 left-20 w-1 h-1 bg-cyan-300 rounded-full animate-twinkle animation-delay-3000"></div>
        <div class="absolute bottom-20 right-1/3 w-1 h-1 bg-white rounded-full animate-twinkle animation-delay-4000"></div>
      </div>
    </div>

    <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative">
      <!-- Section Header -->
      <div class="text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-bold text-white mb-6">
          Success <span class="bg-gradient-to-r from-indigo-400 to-cyan-400 bg-clip-text text-transparent">Stories</span>
        </h2>
        <p class="text-xl text-gray-300 max-w-3xl mx-auto leading-relaxed">
          Real students, real achievements. Discover how QwikTest has transformed careers and opened new opportunities
        </p>
      </div>

      <!-- Featured Success Story -->
      <div class="mb-16">
        <div class="bg-gradient-to-r from-slate-800/50 to-slate-700/50 backdrop-blur-sm border border-slate-600/30 rounded-3xl p-8 lg:p-12">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <!-- Image/Video -->
            <div class="relative group">
              <div class="aspect-[4/3] bg-gradient-to-br from-indigo-500 to-purple-600 rounded-2xl overflow-hidden shadow-2xl">
                <!-- Student photo placeholder with professional styling -->
                <div class="w-full h-full flex items-center justify-center relative">
                  <div class="w-48 h-48 bg-white/10 backdrop-blur-sm rounded-full flex items-center justify-center">
                    <div class="w-32 h-32 bg-gradient-to-br from-indigo-300 to-purple-300 rounded-full flex items-center justify-center">
                      <i class="pi pi-user text-indigo-800 text-4xl"></i>
                    </div>
                  </div>
                  <!-- Achievement badges -->
                  <div class="absolute top-4 right-4 flex flex-col gap-2">
                    <div class="w-12 h-12 bg-yellow-500 rounded-full flex items-center justify-center shadow-lg">
                      <i class="pi pi-trophy text-white text-lg"></i>
                    </div>
                    <div class="w-12 h-12 bg-green-500 rounded-full flex items-center justify-center shadow-lg">
                      <i class="pi pi-check-circle text-white text-lg"></i>
                    </div>
                  </div>
                  <!-- Company logo placeholder -->
                  <div class="absolute bottom-4 left-4 px-4 py-2 bg-white/90 backdrop-blur-sm rounded-lg">
                    <span class="text-gray-800 font-semibold text-sm">Google</span>
                  </div>
                </div>
              </div>
              <!-- Play button for video testimonial -->
              <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity duration-300">
                <div class="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-full flex items-center justify-center cursor-pointer hover:scale-110 transition-transform duration-300">
                  <i class="pi pi-play text-white text-2xl ml-1"></i>
                </div>
              </div>
            </div>

            <!-- Content -->
            <div>
              <div class="flex items-center gap-3 mb-6">
                <div class="flex">
                  <i class="pi pi-star-fill text-yellow-400 text-lg"></i>
                  <i class="pi pi-star-fill text-yellow-400 text-lg"></i>
                  <i class="pi pi-star-fill text-yellow-400 text-lg"></i>
                  <i class="pi pi-star-fill text-yellow-400 text-lg"></i>
                  <i class="pi pi-star-fill text-yellow-400 text-lg"></i>
                </div>
                <span class="text-gray-300 text-sm">Featured Story</span>
              </div>

              <blockquote class="text-2xl md:text-3xl font-light text-white mb-6 leading-relaxed">
                "QwikTest didn't just teach me skills - it transformed my entire career trajectory. From a junior developer to a senior engineer at Google in just 18 months."
              </blockquote>

              <div class="mb-8">
                <h4 class="text-xl font-bold text-white mb-2">Sarah Chen</h4>
                <p class="text-indigo-300 mb-2">Senior Software Engineer, Google</p>
                <p class="text-gray-400 text-sm">Completed: Advanced Full-Stack Development Path</p>
              </div>

              <div class="grid grid-cols-3 gap-6 mb-8">
                <div class="text-center">
                  <div class="text-3xl font-bold text-indigo-400 mb-1">18</div>
                  <div class="text-gray-400 text-xs">Months to Success</div>
                </div>
                <div class="text-center">
                  <div class="text-3xl font-bold text-green-400 mb-1">300%</div>
                  <div class="text-gray-400 text-xs">Salary Increase</div>
                </div>
                <div class="text-center">
                  <div class="text-3xl font-bold text-purple-400 mb-1">12</div>
                  <div class="text-gray-400 text-xs">Certifications Earned</div>
                </div>
              </div>

              <Link
                href="/stories/sarah-chen"
                class="inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 transform hover:scale-105"
              >
                Read Full Story
                <i class="pi pi-arrow-right text-sm"></i>
              </Link>
            </div>
          </div>
        </div>
      </div>

      <!-- Success Stories Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
        <!-- Story 1: Career Change -->
        <div class="group">
          <div class="bg-slate-800/30 backdrop-blur-sm border border-slate-600/30 rounded-2xl p-6 hover:bg-slate-800/50 transition-all duration-500 hover:transform hover:scale-105">
            <!-- Avatar and company -->
            <div class="flex items-center gap-4 mb-6">
              <div class="w-16 h-16 bg-gradient-to-br from-emerald-400 to-green-500 rounded-full flex items-center justify-center">
                <i class="pi pi-user text-white text-xl"></i>
              </div>
              <div>
                <h4 class="text-white font-semibold">Marcus Rodriguez</h4>
                <p class="text-emerald-300 text-sm">Data Scientist, Microsoft</p>
                <p class="text-gray-400 text-xs">Career Changer</p>
              </div>
            </div>

            <blockquote class="text-gray-300 mb-6 leading-relaxed">
              "From restaurant manager to data scientist in 14 months. QwikTest's structured approach made the impossible possible."
            </blockquote>

            <div class="flex items-center justify-between mb-4">
              <div class="flex">
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
              </div>
              <span class="text-emerald-400 font-semibold text-sm">+250% salary</span>
            </div>

            <div class="text-center">
              <Link
                href="/stories/marcus-rodriguez"
                class="text-indigo-400 hover:text-indigo-300 font-medium text-sm transition-colors duration-300"
              >
                View Story →
              </Link>
            </div>
          </div>
        </div>

        <!-- Story 2: Recent Graduate -->
        <div class="group">
          <div class="bg-slate-800/30 backdrop-blur-sm border border-slate-600/30 rounded-2xl p-6 hover:bg-slate-800/50 transition-all duration-500 hover:transform hover:scale-105">
            <!-- Avatar and company -->
            <div class="flex items-center gap-4 mb-6">
              <div class="w-16 h-16 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full flex items-center justify-center">
                <i class="pi pi-user text-white text-xl"></i>
              </div>
              <div>
                <h4 class="text-white font-semibold">Priya Patel</h4>
                <p class="text-purple-300 text-sm">Product Manager, Stripe</p>
                <p class="text-gray-400 text-xs">Recent Graduate</p>
              </div>
            </div>

            <blockquote class="text-gray-300 mb-6 leading-relaxed">
              "Fresh out of college, QwikTest gave me the practical skills that university couldn't. Landed my dream job in 3 months!"
            </blockquote>

            <div class="flex items-center justify-between mb-4">
              <div class="flex">
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
              </div>
              <span class="text-purple-400 font-semibold text-sm">6 job offers</span>
            </div>

            <div class="text-center">
              <Link
                href="/stories/priya-patel"
                class="text-indigo-400 hover:text-indigo-300 font-medium text-sm transition-colors duration-300"
              >
                View Story →
              </Link>
            </div>
          </div>
        </div>

        <!-- Story 3: Entrepreneur -->
        <div class="group">
          <div class="bg-slate-800/30 backdrop-blur-sm border border-slate-600/30 rounded-2xl p-6 hover:bg-slate-800/50 transition-all duration-500 hover:transform hover:scale-105">
            <!-- Avatar and company -->
            <div class="flex items-center gap-4 mb-6">
              <div class="w-16 h-16 bg-gradient-to-br from-orange-400 to-red-500 rounded-full flex items-center justify-center">
                <i class="pi pi-user text-white text-xl"></i>
              </div>
              <div>
                <h4 class="text-white font-semibold">Alex Thompson</h4>
                <p class="text-orange-300 text-sm">Founder, TechFlow</p>
                <p class="text-gray-400 text-xs">Entrepreneur</p>
              </div>
            </div>

            <blockquote class="text-gray-300 mb-6 leading-relaxed">
              "Built my startup from the ground up using skills learned on QwikTest. Now we're a team of 50 with $2M ARR."
            </blockquote>

            <div class="flex items-center justify-between mb-4">
              <div class="flex">
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
                <i class="pi pi-star-fill text-yellow-400"></i>
              </div>
              <span class="text-orange-400 font-semibold text-sm">$2M ARR</span>
            </div>

            <div class="text-center">
              <Link
                href="/stories/alex-thompson"
                class="text-indigo-400 hover:text-indigo-300 font-medium text-sm transition-colors duration-300"
              >
                View Story →
              </Link>
            </div>
          </div>
        </div>
      </div>

      <!-- Community Stats -->
      <div class="bg-gradient-to-r from-slate-800/50 to-slate-700/50 backdrop-blur-sm border border-slate-600/30 rounded-3xl p-8 mb-16">
        <h3 class="text-3xl font-bold text-white text-center mb-12">Our Community Impact</h3>
        
        <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
          <div class="text-center group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-indigo-400 to-cyan-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              50K+
            </div>
            <div class="text-gray-300 font-medium">Success Stories</div>
            <div class="text-gray-500 text-sm mt-1">And counting...</div>
          </div>
          
          <div class="text-center group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              89%
            </div>
            <div class="text-gray-300 font-medium">Job Placement</div>
            <div class="text-gray-500 text-sm mt-1">Within 6 months</div>
          </div>
          
          <div class="text-center group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-emerald-400 to-green-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              180%
            </div>
            <div class="text-gray-300 font-medium">Avg Salary Increase</div>
            <div class="text-gray-500 text-sm mt-1">Career advancement</div>
          </div>
          
          <div class="text-center group">
            <div class="text-4xl md:text-5xl font-bold bg-gradient-to-r from-orange-400 to-red-400 bg-clip-text text-transparent mb-2 group-hover:scale-110 transition-transform duration-300">
              4.9
            </div>
            <div class="text-gray-300 font-medium">Average Rating</div>
            <div class="text-gray-500 text-sm mt-1">From 45K+ reviews</div>
          </div>
        </div>
      </div>

      <!-- Testimonial Carousel Preview -->
      <div class="bg-slate-800/30 backdrop-blur-sm border border-slate-600/30 rounded-3xl p-8">
        <div class="flex items-center justify-between mb-8">
          <h3 class="text-2xl font-bold text-white">More Success Stories</h3>
          <Link
            href="/testimonials"
            class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-medium rounded-lg transition-colors duration-300"
          >
            View All
          </Link>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <!-- Quick testimonial 1 -->
          <div class="bg-slate-700/30 rounded-xl p-4">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-10 h-10 bg-gradient-to-br from-cyan-400 to-blue-500 rounded-full flex items-center justify-center">
                <i class="pi pi-user text-white text-sm"></i>
              </div>
              <div>
                <div class="text-white font-medium text-sm">David Kim</div>
                <div class="text-cyan-300 text-xs">Senior DevOps, AWS</div>
              </div>
            </div>
            <p class="text-gray-300 text-sm leading-relaxed">
              "Best investment in my career. The hands-on approach and real projects made all the difference."
            </p>
            <div class="flex mt-3">
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
            </div>
          </div>

          <!-- Quick testimonial 2 -->
          <div class="bg-slate-700/30 rounded-xl p-4">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-10 h-10 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center">
                <i class="pi pi-user text-white text-sm"></i>
              </div>
              <div>
                <div class="text-white font-medium text-sm">Lisa Wong</div>
                <div class="text-green-300 text-xs">UX Designer, Spotify</div>
              </div>
            </div>
            <p class="text-gray-300 text-sm leading-relaxed">
              "From zero design experience to landing at Spotify. QwikTest's design path is incredible."
            </p>
            <div class="flex mt-3">
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
            </div>
          </div>

          <!-- Quick testimonial 3 -->
          <div class="bg-slate-700/30 rounded-xl p-4 md:col-span-2 lg:col-span-1">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-10 h-10 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full flex items-center justify-center">
                <i class="pi pi-user text-white text-sm"></i>
              </div>
              <div>
                <div class="text-white font-medium text-sm">James Miller</div>
                <div class="text-purple-300 text-xs">CTO, StartupXYZ</div>
              </div>
            </div>
            <p class="text-gray-300 text-sm leading-relaxed">
              "Built my technical leadership skills here. Now I'm running a 20-person engineering team."
            </p>
            <div class="flex mt-3">
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
              <i class="pi pi-star-fill text-yellow-400 text-sm"></i>
            </div>
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
/* Blob animation */
@keyframes blob {
  0% {
    transform: translate(0px, 0px) scale(1);
  }
  33% {
    transform: translate(30px, -50px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
  100% {
    transform: translate(0px, 0px) scale(1);
  }
}

.animate-blob {
  animation: blob 20s infinite;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-4000 {
  animation-delay: 4s;
}

/* Twinkle animation for stars */
@keyframes twinkle {
  0%, 100% {
    opacity: 0.3;
    transform: scale(1);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

.animate-twinkle {
  animation: twinkle 3s ease-in-out infinite;
}

.animation-delay-1000 {
  animation-delay: 1s;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-3000 {
  animation-delay: 3s;
}

.animation-delay-4000 {
  animation-delay: 4s;
}

/* Card hover effects */
.group:hover [class*="bg-slate-800/30"] {
  background-color: rgba(30, 41, 59, 0.6);
  border-color: rgba(99, 102, 241, 0.3);
}

/* Stats animation */
.group:hover [class*="text-4xl"],
.group:hover [class*="text-5xl"] {
  animation: pulse-stat 0.6s ease-in-out;
}

@keyframes pulse-stat {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

/* Play button hover effect */
.group:hover [class*="w-20"][class*="h-20"] {
  background-color: rgba(255, 255, 255, 0.3);
  transform: scale(1.1);
}

/* Star rating animations */
.pi-star-fill {
  animation: star-glow 2s ease-in-out infinite;
}

@keyframes star-glow {
  0%, 100% {
    filter: brightness(1);
  }
  50% {
    filter: brightness(1.2);
  }
}

/* Quote styling */
blockquote {
  position: relative;
}

blockquote::before {
  content: '"';
  position: absolute;
  left: -1rem;
  top: -0.5rem;
  font-size: 4rem;
  color: rgba(99, 102, 241, 0.3);
  line-height: 1;
}

/* Mobile responsiveness */
@media (max-width: 768px) {
  [class*="md:col-span-2"] {
    grid-column: span 1;
  }
  
  [class*="grid-cols-4"] {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

/* Background elements animation */
.absolute.inset-0 > div:first-child,
.absolute.inset-0 > div:nth-child(2),
.absolute.inset-0 > div:nth-child(3) {
  animation: float-bg 25s ease-in-out infinite;
}

@keyframes float-bg {
  0%, 100% {
    transform: translateY(0px) translateX(0px);
    opacity: 0.2;
  }
  25% {
    transform: translateY(-30px) translateX(20px);
    opacity: 0.3;
  }
  50% {
    transform: translateY(0px) translateX(-20px);
    opacity: 0.25;
  }
  75% {
    transform: translateY(30px) translateX(10px);
    opacity: 0.35;
  }
}
</style>