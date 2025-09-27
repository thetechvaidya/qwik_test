<template>
  <svg 
    :width="width" 
    :height="height" 
    :class="className"
    viewBox="0 0 200 60" 
    fill="none" 
    xmlns="http://www.w3.org/2000/svg"
  >
    <!-- Background Circle -->
    <circle 
      cx="30" 
      cy="30" 
      r="25" 
      :fill="variant === 'dark' ? 'url(#logoDarkGradient)' : 'url(#logoGradient)'" 
    />
    
    <!-- Main Q Letter with Lightning -->
    <g transform="translate(30, 30)">
      <!-- Q Letter -->
      <circle 
        cx="0" 
        cy="-2" 
        r="12" 
        stroke="white" 
        stroke-width="3" 
        fill="none"
      />
      <line 
        x1="8" 
        y1="6" 
        x2="12" 
        y2="10" 
        stroke="white" 
        stroke-width="3" 
        stroke-linecap="round"
      />
      
      <!-- Lightning Bolt (representing "Quick") -->
      <path 
        d="M-8 -8 L-2 -2 L-6 -2 L0 4 L-4 0 L-2 0 Z" 
        fill="#FCD34D"
        class="lightning-bolt"
      >
        <animate 
          attributeName="fill" 
          values="#FCD34D;#F59E0B;#FCD34D" 
          dur="2s" 
          repeatCount="indefinite"
        />
      </path>
    </g>
    
    <!-- Text: QwikTest -->
    <text 
      x="65" 
      y="25" 
      :fill="variant === 'dark' ? '#FFFFFF' : '#1F2937'"
      font-family="Inter, sans-serif" 
      font-size="18" 
      font-weight="700"
    >
      Qwik
    </text>
    <text 
      x="65" 
      y="45" 
      :fill="variant === 'dark' ? '#D1D5DB' : '#6B7280'"
      font-family="Inter, sans-serif" 
      font-size="14" 
      font-weight="500"
    >
      Test
    </text>
    
    <!-- Decorative Elements -->
    <circle 
      cx="150" 
      cy="15" 
      r="2" 
      :fill="variant === 'dark' ? '#10B981' : '#059669'"
      opacity="0.8"
    >
      <animate 
        attributeName="opacity" 
        values="0.4;1;0.4" 
        dur="3s" 
        repeatCount="indefinite"
      />
    </circle>
    
    <circle 
      cx="160" 
      cy="45" 
      r="1.5" 
      :fill="variant === 'dark' ? '#3B82F6' : '#2563EB'"
      opacity="0.6"
    >
      <animate 
        attributeName="opacity" 
        values="0.6;1;0.6" 
        dur="2.5s" 
        repeatCount="indefinite" 
        begin="0.5s"
      />
    </circle>
    
    <rect 
      x="170" 
      y="25" 
      width="3" 
      height="3" 
      rx="1" 
      :fill="variant === 'dark' ? '#EC4899' : '#DB2777'"
      opacity="0.7"
    >
      <animateTransform 
        attributeName="transform" 
        type="rotate" 
        values="0 171.5 26.5;360 171.5 26.5" 
        dur="4s" 
        repeatCount="indefinite"
      />
    </rect>
    
    <!-- Gradient Definitions -->
    <defs>
      <!-- Light Theme Gradient -->
      <linearGradient id="logoGradient" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#4F46E5;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#7C3AED;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#EC4899;stop-opacity:1" />
      </linearGradient>
      
      <!-- Dark Theme Gradient -->
      <linearGradient id="logoDarkGradient" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#6366F1;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#8B5CF6;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#F472B6;stop-opacity:1" />
      </linearGradient>
    </defs>
  </svg>
</template>

<script setup>
defineProps({
  width: {
    type: [String, Number],
    default: 200
  },
  height: {
    type: [String, Number],
    default: 60
  },
  variant: {
    type: String,
    default: 'light', // 'light' | 'dark'
    validator: (value) => ['light', 'dark'].includes(value)
  },
  className: {
    type: String,
    default: ''
  }
})
</script>

<style scoped>
.lightning-bolt {
  transform-origin: center;
}

svg {
  transition: all 0.3s ease;
}

svg:hover .lightning-bolt {
  animation: lightning-pulse 0.5s ease-in-out;
}

@keyframes lightning-pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.1); }
  100% { transform: scale(1); }
}
</style>