<template>
  <svg 
    :width="size" 
    :height="size" 
    :class="className"
    viewBox="0 0 60 60" 
    fill="none" 
    xmlns="http://www.w3.org/2000/svg"
  >
    <!-- Background Circle -->
    <circle 
      cx="30" 
      cy="30" 
      r="28" 
      :fill="variant === 'dark' ? 'url(#iconDarkGradient)' : 'url(#iconGradient)'" 
    />
    
    <!-- Inner Circle for Depth -->
    <circle 
      cx="30" 
      cy="30" 
      r="22" 
      fill="rgba(255,255,255,0.1)" 
    />
    
    <!-- Main Q Letter with Lightning -->
    <g transform="translate(30, 30)">
      <!-- Q Letter -->
      <circle 
        cx="0" 
        cy="0" 
        r="10" 
        stroke="white" 
        stroke-width="2.5" 
        fill="none"
      />
      <line 
        x1="7" 
        y1="7" 
        x2="11" 
        y2="11" 
        stroke="white" 
        stroke-width="2.5" 
        stroke-linecap="round"
      />
      
      <!-- Lightning Bolt -->
      <path 
        d="M-6 -6 L-1 -1 L-4 -1 L1 5 L-3 1 L-1 1 Z" 
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
    
    <!-- Gradient Definitions -->
    <defs>
      <linearGradient id="iconGradient" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#4F46E5;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#7C3AED;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#EC4899;stop-opacity:1" />
      </linearGradient>
      
      <linearGradient id="iconDarkGradient" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#6366F1;stop-opacity:1" />
        <stop offset="50%" style="stop-color:#8B5CF6;stop-opacity:1" />
        <stop offset="100%" style="stop-color:#F472B6;stop-opacity:1" />
      </linearGradient>
    </defs>
  </svg>
</template>

<script setup>
defineProps({
  size: {
    type: [String, Number],
    default: 60
  },
  variant: {
    type: String,
    default: 'light',
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

svg:hover {
  transform: scale(1.05);
}

svg:hover .lightning-bolt {
  animation: lightning-pulse 0.5s ease-in-out;
}

@keyframes lightning-pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}
</style>