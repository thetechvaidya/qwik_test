<template>
  <!-- Newsletter Section -->
  <section class="py-20 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 relative overflow-hidden">
    <!-- Background Pattern -->
    <div class="absolute inset-0">
      <!-- Geometric shapes -->
      <div class="absolute top-0 left-0 w-full h-full">
        <svg class="absolute inset-0 w-full h-full opacity-10" viewBox="0 0 1000 1000" fill="none" xmlns="http://www.w3.org/2000/svg">
          <defs>
            <pattern id="newsletter-pattern" x="0" y="0" width="100" height="100" patternUnits="userSpaceOnUse">
              <circle cx="50" cy="50" r="25" stroke="white" stroke-width="1" fill="none" opacity="0.3"/>
              <circle cx="50" cy="50" r="15" stroke="white" stroke-width="1" fill="none" opacity="0.2"/>
              <circle cx="50" cy="50" r="5" fill="white" opacity="0.1"/>
            </pattern>
          </defs>
          <rect width="100%" height="100%" fill="url(#newsletter-pattern)" class="text-white"/>
        </svg>
      </div>

      <!-- Floating elements -->
      <div class="absolute top-20 left-10 w-32 h-32 bg-white/10 rounded-full blur-xl animate-float"></div>
      <div class="absolute top-1/2 right-20 w-24 h-24 bg-white/10 rounded-full blur-xl animate-float animation-delay-2000"></div>
      <div class="absolute bottom-20 left-1/3 w-40 h-40 bg-white/10 rounded-full blur-xl animate-float animation-delay-4000"></div>

      <!-- Email icons floating -->
      <div class="absolute top-1/4 left-1/4 text-white/20 animate-bounce-slow">
        <i class="pi pi-envelope text-3xl"></i>
      </div>
      <div class="absolute top-3/4 right-1/4 text-white/20 animate-bounce-slow animation-delay-3000">
        <i class="pi pi-send text-2xl"></i>
      </div>
    </div>

    <div class="container mx-auto px-4 sm:px-6 lg:px-8 relative">
      <div class="max-w-4xl mx-auto text-center">
        <!-- Section Header -->
        <div class="mb-12">
          <div class="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mx-auto mb-8">
            <i class="pi pi-bell text-white text-3xl"></i>
          </div>
          
          <h2 class="text-4xl md:text-5xl font-bold text-white mb-6">
            Stay Ahead of the Curve
          </h2>
          <p class="text-xl text-white/90 leading-relaxed max-w-2xl mx-auto">
            Get the latest learning resources, industry insights, career tips, and exclusive content delivered straight to your inbox
          </p>
        </div>

        <!-- Newsletter Form -->
        <div class="bg-white/10 backdrop-blur-sm border border-white/20 rounded-3xl p-8 md:p-12 mb-12">
          <form class="space-y-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <!-- Email Input -->
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <i class="pi pi-envelope text-white/60"></i>
                </div>
                <input
                  type="email"
                  placeholder="Enter your email address"
                  class="w-full pl-12 pr-4 py-4 bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl text-white placeholder-white/70 focus:border-white/50 focus:ring-2 focus:ring-white/25 focus:outline-none transition-all duration-300"
                  required
                />
              </div>

              <!-- Name Input -->
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                  <i class="pi pi-user text-white/60"></i>
                </div>
                <input
                  type="text"
                  placeholder="Your first name"
                  class="w-full pl-12 pr-4 py-4 bg-white/20 backdrop-blur-sm border border-white/30 rounded-xl text-white placeholder-white/70 focus:border-white/50 focus:ring-2 focus:ring-white/25 focus:outline-none transition-all duration-300"
                  required
                />
              </div>
            </div>

            <!-- Preferences -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <label class="flex items-center gap-3 cursor-pointer group">
                <input type="checkbox" class="sr-only" checked />
                <div class="w-5 h-5 bg-white/20 border border-white/30 rounded flex items-center justify-center group-hover:bg-white/30 transition-colors duration-300">
                  <i class="pi pi-check text-white text-xs"></i>
                </div>
                <span class="text-white/90 text-sm">Course Updates</span>
              </label>

              <label class="flex items-center gap-3 cursor-pointer group">
                <input type="checkbox" class="sr-only" checked />
                <div class="w-5 h-5 bg-white/20 border border-white/30 rounded flex items-center justify-center group-hover:bg-white/30 transition-colors duration-300">
                  <i class="pi pi-check text-white text-xs"></i>
                </div>
                <span class="text-white/90 text-sm">Career Tips</span>
              </label>

              <label class="flex items-center gap-3 cursor-pointer group">
                <input type="checkbox" class="sr-only" />
                <div class="w-5 h-5 bg-white/20 border border-white/30 rounded flex items-center justify-center group-hover:bg-white/30 transition-colors duration-300">
                  <!-- Empty for unchecked -->
                </div>
                <span class="text-white/90 text-sm">Special Offers</span>
              </label>
            </div>

            <!-- Submit Button -->
            <div class="flex flex-col sm:flex-row items-center gap-4">
              <button
                type="submit"
                class="w-full sm:w-auto px-8 py-4 bg-white text-indigo-600 font-bold rounded-xl hover:bg-white/90 focus:bg-white/90 transition-all duration-300 transform hover:scale-105 shadow-lg hover:shadow-xl flex items-center justify-center gap-2 group"
              >
                <span>Subscribe Now</span>
                <i class="pi pi-arrow-right text-sm group-hover:translate-x-1 transition-transform duration-300"></i>
              </button>
              
              <p class="text-white/70 text-sm text-center sm:text-left">
                Join <span class="font-semibold text-white">25,000+</span> learners already subscribed
              </p>
            </div>
          </form>
        </div>

        <!-- Benefits Preview -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
          <!-- Benefit 1 -->
          <div class="text-center group">
            <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:bg-white/30 transition-all duration-300 group-hover:scale-110">
              <i class="pi pi-book text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-white mb-3">Weekly Learning Resources</h3>
            <p class="text-white/80 text-sm leading-relaxed">
              Curated articles, tutorials, and tools to accelerate your learning journey
            </p>
          </div>

          <!-- Benefit 2 -->
          <div class="text-center group">
            <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:bg-white/30 transition-all duration-300 group-hover:scale-110">
              <i class="pi pi-users text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-white mb-3">Exclusive Community Access</h3>
            <p class="text-white/80 text-sm leading-relaxed">
              Join our private community of learners and get access to exclusive events
            </p>
          </div>

          <!-- Benefit 3 -->
          <div class="text-center group">
            <div class="w-16 h-16 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:bg-white/30 transition-all duration-300 group-hover:scale-110">
              <i class="pi pi-star text-white text-2xl"></i>
            </div>
            <h3 class="text-xl font-bold text-white mb-3">Early Access & Discounts</h3>
            <p class="text-white/80 text-sm leading-relaxed">
              Be the first to access new courses and get subscriber-only discounts
            </p>
          </div>
        </div>

        <!-- Recent Newsletter Preview -->
        <div class="bg-white/10 backdrop-blur-sm border border-white/20 rounded-2xl p-8 mb-12">
          <h3 class="text-2xl font-bold text-white mb-6">Latest Newsletter Highlights</h3>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 text-left">
            <!-- Article 1 -->
            <div class="bg-white/10 rounded-xl p-6 hover:bg-white/20 transition-colors duration-300">
              <div class="flex items-start gap-4">
                <div class="w-12 h-12 bg-gradient-to-br from-cyan-400 to-blue-500 rounded-lg flex items-center justify-center flex-shrink-0">
                  <i class="pi pi-code text-white"></i>
                </div>
                <div>
                  <h4 class="text-white font-semibold mb-2">Top 10 Programming Trends for 2024</h4>
                  <p class="text-white/80 text-sm mb-2">
                    Discover the technologies that will shape the future of development
                  </p>
                  <span class="text-white/60 text-xs">Issue #127 • 5 min read</span>
                </div>
              </div>
            </div>

            <!-- Article 2 -->
            <div class="bg-white/10 rounded-xl p-6 hover:bg-white/20 transition-colors duration-300">
              <div class="flex items-start gap-4">
                <div class="w-12 h-12 bg-gradient-to-br from-emerald-400 to-green-500 rounded-lg flex items-center justify-center flex-shrink-0">
                  <i class="pi pi-briefcase text-white"></i>
                </div>
                <div>
                  <h4 class="text-white font-semibold mb-2">How Sarah Got 6 Job Offers</h4>
                  <p class="text-white/80 text-sm mb-2">
                    Real strategies from our community members who landed dream jobs
                  </p>
                  <span class="text-white/60 text-xs">Issue #126 • 8 min read</span>
                </div>
              </div>
            </div>

            <!-- Article 3 -->
            <div class="bg-white/10 rounded-xl p-6 hover:bg-white/20 transition-colors duration-300">
              <div class="flex items-start gap-4">
                <div class="w-12 h-12 bg-gradient-to-br from-purple-400 to-pink-500 rounded-lg flex items-center justify-center flex-shrink-0">
                  <i class="pi pi-lightbulb text-white"></i>
                </div>
                <div>
                  <h4 class="text-white font-semibold mb-2">AI Tools for Developers</h4>
                  <p class="text-white/80 text-sm mb-2">
                    Productivity-boosting AI tools that every developer should know
                  </p>
                  <span class="text-white/60 text-xs">Issue #125 • 6 min read</span>
                </div>
              </div>
            </div>

            <!-- Article 4 -->
            <div class="bg-white/10 rounded-xl p-6 hover:bg-white/20 transition-colors duration-300">
              <div class="flex items-start gap-4">
                <div class="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center flex-shrink-0">
                  <i class="pi pi-chart-line text-white"></i>
                </div>
                <div>
                  <h4 class="text-white font-semibold mb-2">Salary Negotiation Masterclass</h4>
                  <p class="text-white/80 text-sm mb-2">
                    Expert tips to maximize your earning potential in tech
                  </p>
                  <span class="text-white/60 text-xs">Issue #124 • 10 min read</span>
                </div>
              </div>
            </div>
          </div>

          <div class="text-center mt-8">
            <Link
              href="/newsletter/archive"
              class="inline-flex items-center gap-2 px-6 py-3 bg-white/20 hover:bg-white/30 text-white font-semibold rounded-xl transition-all duration-300"
            >
              View Newsletter Archive
              <i class="pi pi-external-link text-sm"></i>
            </Link>
          </div>
        </div>

        <!-- Social Proof -->
        <div class="text-center">
          <p class="text-white/70 mb-6">Trusted by learners at</p>
          <div class="flex items-center justify-center gap-8 flex-wrap opacity-60">
            <!-- Company logos as text for simplicity -->
            <div class="px-6 py-3 bg-white/10 rounded-lg">
              <span class="text-white font-semibold">Google</span>
            </div>
            <div class="px-6 py-3 bg-white/10 rounded-lg">
              <span class="text-white font-semibold">Microsoft</span>
            </div>
            <div class="px-6 py-3 bg-white/10 rounded-lg">
              <span class="text-white font-semibold">Netflix</span>
            </div>
            <div class="px-6 py-3 bg-white/10 rounded-lg">
              <span class="text-white font-semibold">Spotify</span>
            </div>
            <div class="px-6 py-3 bg-white/10 rounded-lg">
              <span class="text-white font-semibold">Stripe</span>
            </div>
          </div>
        </div>

        <!-- Privacy Notice -->
        <div class="mt-12 text-center">
          <p class="text-white/60 text-sm">
            We respect your privacy. Unsubscribe at any time. Read our 
            <Link href="/privacy" class="text-white hover:text-white/80 underline transition-colors duration-300">
              Privacy Policy
            </Link>
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
</script>

<style scoped>
/* Float animation */
@keyframes float {
  0%, 100% {
    transform: translateY(0px) scale(1);
  }
  50% {
    transform: translateY(-20px) scale(1.05);
  }
}

.animate-float {
  animation: float 6s ease-in-out infinite;
}

.animation-delay-2000 {
  animation-delay: 2s;
}

.animation-delay-4000 {
  animation-delay: 4s;
}

/* Slow bounce animation */
@keyframes bounce-slow {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.animate-bounce-slow {
  animation: bounce-slow 4s ease-in-out infinite;
}

.animation-delay-3000 {
  animation-delay: 3s;
}

/* Input focus effects */
input:focus {
  box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
}

/* Button hover effects */
button:hover {
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
}

/* Checkbox animation */
input[type="checkbox"]:checked + div {
  background-color: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
}

/* Background pattern animation */
.absolute.inset-0 svg {
  animation: pattern-rotate 60s linear infinite;
}

@keyframes pattern-rotate {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Benefit icons hover animation */
.group:hover .w-16.h-16 {
  transform: scale(1.1) rotate(5deg);
}

/* Newsletter preview hover effects */
[class*="bg-white/10"][class*="rounded-xl"]:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

/* Social proof animation */
[class*="px-6"][class*="py-3"][class*="bg-white/10"] {
  animation: fade-in-up 1s ease-out;
}

@keyframes fade-in-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 0.6;
    transform: translateY(0);
  }
}

/* Form validation styles */
input:invalid {
  border-color: rgba(239, 68, 68, 0.5);
}

input:valid {
  border-color: rgba(34, 197, 94, 0.5);
}

/* Mobile responsiveness */
@media (max-width: 768px) {
  [class*="grid-cols-3"] {
    grid-template-columns: repeat(1, minmax(0, 1fr));
  }
  
  [class*="md:grid-cols-2"] {
    grid-template-columns: repeat(1, minmax(0, 1fr));
  }
  
  [class*="flex-wrap"] {
    justify-content: center;
  }
  
  [class*="px-6"][class*="py-3"] {
    margin: 0.25rem;
  }
}

/* Gradient animation */
.bg-gradient-to-br {
  background-size: 400% 400%;
  animation: gradient-shift 15s ease infinite;
}

@keyframes gradient-shift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* Arrow animation in button */
.group:hover .pi-arrow-right {
  transform: translateX(4px);
}
</style>