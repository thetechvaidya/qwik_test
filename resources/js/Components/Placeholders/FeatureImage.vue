<template>
  <div class="feature-image-placeholder">
    <svg
      :width="width"
      :height="height"
      viewBox="0 0 400 300"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      class="w-full h-full"
    >
      <!-- Background Gradient -->
      <defs>
        <linearGradient id="featureGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#e0e7ff" />
          <stop offset="100%" stop-color="#f3e8ff" />
        </linearGradient>
        <linearGradient id="iconGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#6366f1" />
          <stop offset="100%" stop-color="#8b5cf6" />
        </linearGradient>
        <filter id="shadow">
          <feDropShadow dx="2" dy="4" stdDeviation="3" flood-opacity="0.1"/>
        </filter>
      </defs>
      
      <!-- Background -->
      <rect width="400" height="300" fill="url(#featureGradient)" rx="12" />
      
      <!-- Feature Icon Container -->
      <g transform="translate(200, 150)">
        <!-- Main Circle -->
        <circle cx="0" cy="0" r="60" fill="white" filter="url(#shadow)" />
        <circle cx="0" cy="0" r="45" fill="url(#iconGradient)" opacity="0.1" />
        
        <!-- Dynamic Icon Based on Type -->
        <g v-if="iconType === 'quiz'">
          <!-- Quiz Icon -->
          <rect x="-20" y="-25" width="40" height="50" rx="6" fill="url(#iconGradient)" />
          <circle cx="0" cy="-10" r="12" fill="white" />
          <text x="0" y="-5" text-anchor="middle" fill="url(#iconGradient)" font-size="16" font-weight="bold">?</text>
          <!-- Answer dots -->
          <circle cx="-12" cy="8" r="3" fill="white" />
          <circle cx="-12" cy="18" r="3" fill="white" />
          <circle cx="12" cy="8" r="3" fill="white" />
          <circle cx="12" cy="18" r="3" fill="white" />
        </g>
        
        <g v-else-if="iconType === 'analytics'">
          <!-- Analytics Icon -->
          <rect x="-25" y="-15" width="50" height="30" rx="4" fill="url(#iconGradient)" />
          <!-- Chart bars -->
          <rect x="-18" y="-8" width="6" height="16" fill="white" />
          <rect x="-8" y="-12" width="6" height="20" fill="white" />
          <rect x="2" y="-5" width="6" height="13" fill="white" />
          <rect x="12" y="-10" width="6" height="18" fill="white" />
        </g>
        
        <g v-else-if="iconType === 'progress'">
          <!-- Progress Icon -->
          <circle cx="0" cy="0" r="20" fill="none" stroke="url(#iconGradient)" stroke-width="4" />
          <circle cx="0" cy="0" r="20" fill="none" stroke="white" stroke-width="4" 
                  stroke-dasharray="75 25" stroke-dashoffset="0" transform="rotate(-90)" />
          <text x="0" y="5" text-anchor="middle" fill="url(#iconGradient)" font-size="12" font-weight="bold">75%</text>
        </g>
        
        <g v-else-if="iconType === 'certificate'">
          <!-- Certificate Icon -->
          <rect x="-20" y="-15" width="40" height="30" rx="3" fill="url(#iconGradient)" />
          <circle cx="15" cy="-20" r="8" fill="#fbbf24" />
          <polygon points="15,-25 17,-19 23,-19 18,-15 20,-9 15,-12 10,-9 12,-15 7,-19 13,-19" fill="white" />
          <!-- Certificate lines -->
          <line x1="-12" y1="-8" x2="8" y2="-8" stroke="white" stroke-width="2" />
          <line x1="-12" y1="-2" x2="12" y2="-2" stroke="white" stroke-width="2" />
          <line x1="-12" y1="4" x2="6" y2="4" stroke="white" stroke-width="2" />
        </g>
        
        <g v-else>
          <!-- Default Learning Icon -->
          <rect x="-15" y="-20" width="30" height="40" rx="3" fill="url(#iconGradient)" />
          <line x1="0" y1="-20" x2="0" y2="20" stroke="white" stroke-width="2" />
          <line x1="-8" y1="-12" x2="8" y2="-12" stroke="white" stroke-width="1.5" />
          <line x1="-8" y1="-6" x2="8" y2="-6" stroke="white" stroke-width="1.5" />
          <line x1="-8" y1="0" x2="8" y2="0" stroke="white" stroke-width="1.5" />
          <line x1="-8" y1="6" x2="8" y2="6" stroke="white" stroke-width="1.5" />
          <line x1="-8" y1="12" x2="8" y2="12" stroke="white" stroke-width="1.5" />
        </g>
      </g>
      
      <!-- Decorative Elements -->
      <g opacity="0.3">
        <circle cx="80" cy="80" r="4" fill="#6366f1">
          <animate attributeName="r" values="4;6;4" dur="2s" repeatCount="indefinite" />
        </circle>
        <circle cx="320" cy="220" r="3" fill="#8b5cf6">
          <animate attributeName="r" values="3;5;3" dur="3s" repeatCount="indefinite" />
        </circle>
        <rect x="50" y="200" width="8" height="8" rx="2" fill="#ec4899" transform="rotate(45 54 204)">
          <animateTransform attributeName="transform" type="rotate" values="45 54 204;90 54 204;45 54 204" dur="4s" repeatCount="indefinite" />
        </rect>
      </g>
      
      <!-- Feature Title -->
      <text x="200" y="280" text-anchor="middle" fill="#4b5563" font-size="14" font-weight="600" font-family="Arial, sans-serif">
        {{ title || 'Feature Title' }}
      </text>
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
  iconType: {
    type: String,
    default: 'default',
    validator: (value) => ['quiz', 'analytics', 'progress', 'certificate', 'default'].includes(value)
  }
})
</script>

<style scoped>
.feature-image-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
  border-radius: 0.75rem;
  overflow: hidden;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.feature-image-placeholder:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.feature-image-placeholder svg {
  max-width: 100%;
  height: auto;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .feature-image-placeholder {
    border-radius: 0.5rem;
  }
}
</style>