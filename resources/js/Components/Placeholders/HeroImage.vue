<template>
  <div class="hero-image-placeholder">
    <svg
      :width="width"
      :height="height"
      viewBox="0 0 800 600"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      class="w-full h-full"
    >
      <!-- Background Gradient -->
      <defs>
        <linearGradient id="heroGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#667eea" />
          <stop offset="50%" stop-color="#764ba2" />
          <stop offset="100%" stop-color="#f093fb" />
        </linearGradient>
        <linearGradient id="accentGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#4facfe" />
          <stop offset="100%" stop-color="#00f2fe" />
        </linearGradient>
        <filter id="glow">
          <feGaussianBlur stdDeviation="3" result="coloredBlur"/>
          <feMerge> 
            <feMergeNode in="coloredBlur"/>
            <feMergeNode in="SourceGraphic"/> 
          </feMerge>
        </filter>
      </defs>
      
      <!-- Background -->
      <rect width="800" height="600" fill="url(#heroGradient)" opacity="0.1" />
      
      <!-- Abstract Shapes -->
      <circle cx="200" cy="150" r="80" fill="url(#accentGradient)" opacity="0.3" />
      <circle cx="600" cy="400" r="120" fill="url(#accentGradient)" opacity="0.2" />
      <rect x="500" y="100" width="150" height="150" rx="20" fill="url(#heroGradient)" opacity="0.4" transform="rotate(15 575 175)" />
      
      <!-- Learning Elements -->
      <!-- Book Icon -->
      <g transform="translate(300, 200)">
        <rect x="0" y="20" width="120" height="80" rx="8" fill="#667eea" opacity="0.8" />
        <rect x="10" y="10" width="120" height="80" rx="8" fill="#764ba2" opacity="0.9" />
        <rect x="20" y="0" width="120" height="80" rx="8" fill="url(#accentGradient)" />
        <line x1="80" y1="0" x2="80" y2="80" stroke="white" stroke-width="2" opacity="0.7" />
        <!-- Pages -->
        <line x1="40" y1="20" x2="100" y2="20" stroke="white" stroke-width="1.5" opacity="0.6" />
        <line x1="40" y1="30" x2="110" y2="30" stroke="white" stroke-width="1.5" opacity="0.6" />
        <line x1="40" y1="40" x2="95" y2="40" stroke="white" stroke-width="1.5" opacity="0.6" />
        <line x1="40" y1="50" x2="105" y2="50" stroke="white" stroke-width="1.5" opacity="0.6" />
      </g>
      
      <!-- Quiz/Test Elements -->
      <g transform="translate(450, 300)">
        <!-- Quiz Card -->
        <rect x="0" y="0" width="100" height="120" rx="12" fill="white" stroke="url(#accentGradient)" stroke-width="3" />
        <!-- Question Mark -->
        <circle cx="50" cy="40" r="25" fill="url(#heroGradient)" />
        <text x="50" y="50" text-anchor="middle" fill="white" font-size="24" font-weight="bold">?</text>
        <!-- Answer Options -->
        <circle cx="20" cy="80" r="6" fill="#667eea" />
        <circle cx="20" cy="95" r="6" fill="#764ba2" />
        <circle cx="20" cy="110" r="6" fill="#f093fb" />
        <rect x="35" y="76" width="50" height="4" rx="2" fill="#e5e7eb" />
        <rect x="35" y="91" width="40" height="4" rx="2" fill="#e5e7eb" />
        <rect x="35" y="106" width="45" height="4" rx="2" fill="#e5e7eb" />
      </g>
      
      <!-- Progress/Achievement Elements -->
      <g transform="translate(150, 350)">
        <!-- Trophy -->
        <ellipse cx="40" cy="70" rx="35" ry="15" fill="#fbbf24" />
        <rect x="20" y="40" width="40" height="30" rx="8" fill="url(#accentGradient)" />
        <rect x="35" y="25" width="10" height="20" rx="5" fill="#667eea" />
        <circle cx="40" cy="20" r="8" fill="#f093fb" />
        <!-- Stars -->
        <g transform="translate(100, 20)">
          <polygon points="10,2 12,8 18,8 13,12 15,18 10,14 5,18 7,12 2,8 8,8" fill="#fbbf24" filter="url(#glow)" />
        </g>
        <g transform="translate(120, 40)">
          <polygon points="8,2 9.5,6 14,6 10.5,9 12,13 8,10.5 4,13 5.5,9 2,6 6.5,6" fill="#fbbf24" opacity="0.8" />
        </g>
      </g>
      
      <!-- Learning Path/Arrow -->
      <g transform="translate(100, 450)">
        <path d="M0,20 Q50,0 100,20 Q150,40 200,20 Q250,0 300,20" stroke="url(#accentGradient)" stroke-width="4" fill="none" stroke-dasharray="10,5" opacity="0.7" />
        <!-- Arrow head -->
        <polygon points="290,15 300,20 290,25 295,20" fill="url(#accentGradient)" />
        <!-- Progress dots -->
        <circle cx="50" cy="20" r="5" fill="#667eea" />
        <circle cx="150" cy="20" r="5" fill="#764ba2" />
        <circle cx="250" cy="20" r="5" fill="#f093fb" />
      </g>
      
      <!-- Floating Elements -->
      <g opacity="0.6">
        <circle cx="100" cy="100" r="3" fill="#4facfe">
          <animate attributeName="cy" values="100;90;100" dur="3s" repeatCount="indefinite" />
        </circle>
        <circle cx="700" cy="150" r="4" fill="#f093fb">
          <animate attributeName="cy" values="150;140;150" dur="4s" repeatCount="indefinite" />
        </circle>
        <circle cx="650" cy="500" r="2" fill="#667eea">
          <animate attributeName="cy" values="500;490;500" dur="2.5s" repeatCount="indefinite" />
        </circle>
      </g>
      
      <!-- Text Placeholder -->
      <g transform="translate(50, 520)">
        <text x="0" y="0" fill="#6b7280" font-size="14" font-family="Arial, sans-serif" opacity="0.7">
          {{ title || 'Interactive Learning Experience' }}
        </text>
        <text x="0" y="20" fill="#9ca3af" font-size="12" font-family="Arial, sans-serif" opacity="0.6">
          {{ subtitle || 'Engage, Learn, and Excel with Modern Quiz Platform' }}
        </text>
      </g>
    </svg>
  </div>
</template>

<script setup>
defineProps({
  width: {
    type: [String, Number],
    default: '100%'
  },
  height: {
    type: [String, Number],
    default: '100%'
  },
  title: {
    type: String,
    default: ''
  },
  subtitle: {
    type: String,
    default: ''
  }
})
</script>

<style scoped>
.hero-image-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  border-radius: 1rem;
  overflow: hidden;
}

.hero-image-placeholder svg {
  max-width: 100%;
  height: auto;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .hero-image-placeholder {
    border-radius: 0.5rem;
  }
}
</style>