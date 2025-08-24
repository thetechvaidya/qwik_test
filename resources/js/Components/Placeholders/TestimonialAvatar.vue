<template>
  <div class="testimonial-avatar">
    <svg
      :width="size"
      :height="size"
      viewBox="0 0 100 100"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      class="rounded-full"
    >
      <!-- Background Gradient -->
      <defs>
        <linearGradient :id="gradientId" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" :stop-color="gradientColors.start" />
          <stop offset="100%" :stop-color="gradientColors.end" />
        </linearGradient>
        <filter :id="shadowId">
          <feDropShadow dx="2" dy="4" stdDeviation="3" flood-opacity="0.15"/>
        </filter>
      </defs>
      
      <!-- Background Circle -->
      <circle cx="50" cy="50" r="50" :fill="`url(#${gradientId})`" :filter="`url(#${shadowId})`" />
      
      <!-- Avatar Icon -->
      <g transform="translate(50, 50)">
        <!-- Head -->
        <circle cx="0" cy="-8" r="12" fill="white" opacity="0.9" />
        <!-- Body -->
        <path d="M -18 25 Q -18 15 -12 12 Q -6 10 0 10 Q 6 10 12 12 Q 18 15 18 25 L 18 25 L -18 25 Z" fill="white" opacity="0.9" />
      </g>
      
      <!-- Initial Letter -->
      <text 
        x="50" 
        y="58" 
        text-anchor="middle" 
        :fill="textColor" 
        font-size="24" 
        font-weight="bold" 
        font-family="Arial, sans-serif"
      >
        {{ initial }}
      </text>
    </svg>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  name: {
    type: String,
    required: true
  },
  size: {
    type: [String, Number],
    default: 64
  },
  variant: {
    type: String,
    default: 'default',
    validator: (value) => ['default', 'primary', 'secondary', 'success', 'warning', 'danger'].includes(value)
  }
})

// Generate unique IDs for SVG elements
const gradientId = computed(() => `gradient-${Math.random().toString(36).substr(2, 9)}`)
const shadowId = computed(() => `shadow-${Math.random().toString(36).substr(2, 9)}`)

// Get first letter of name
const initial = computed(() => {
  return props.name.charAt(0).toUpperCase()
})

// Color variants
const colorVariants = {
  default: {
    start: '#6366f1',
    end: '#8b5cf6',
    text: 'white'
  },
  primary: {
    start: '#3b82f6',
    end: '#1d4ed8',
    text: 'white'
  },
  secondary: {
    start: '#6b7280',
    end: '#374151',
    text: 'white'
  },
  success: {
    start: '#10b981',
    end: '#059669',
    text: 'white'
  },
  warning: {
    start: '#f59e0b',
    end: '#d97706',
    text: 'white'
  },
  danger: {
    start: '#ef4444',
    end: '#dc2626',
    text: 'white'
  }
}

const gradientColors = computed(() => {
  return {
    start: colorVariants[props.variant]?.start || colorVariants.default.start,
    end: colorVariants[props.variant]?.end || colorVariants.default.end
  }
})

const textColor = computed(() => {
  return colorVariants[props.variant]?.text || colorVariants.default.text
})
</script>

<style scoped>
.testimonial-avatar {
  display: inline-block;
  transition: transform 0.2s ease;
}

.testimonial-avatar:hover {
  transform: scale(1.05);
}

.testimonial-avatar svg {
  display: block;
}
</style>