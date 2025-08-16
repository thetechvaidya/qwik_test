import { ref, reactive, computed, onMounted, onUnmounted, readonly } from 'vue'

export function useTimer(initialConfig = {}) {
    // Timer configuration
    const config = reactive({
        duration: 0, // Total duration in seconds
        autoStart: false,
        countDown: true, // true for countdown, false for count up
        onComplete: null,
        onTick: null,
        onExpire: null,
        warningTime: 300, // Show warning when 5 minutes remaining
        ...initialConfig,
    })

    // Timer state
    const state = reactive({
        isActive: false,
        isPaused: false,
        isCompleted: false,
        isExpired: false,
        startTime: null,
        pauseTime: null,
        elapsedTime: 0,
        remainingTime: config.duration,
        intervalId: null,
        totalPausedTime: 0,
    })

    // Computed properties
    const currentTime = computed(() => {
        return config.countDown ? state.remainingTime : state.elapsedTime
    })

    const isWarningTime = computed(() => {
        return config.countDown && state.remainingTime <= config.warningTime && state.remainingTime > 0
    })

    const isExpiring = computed(() => {
        return config.countDown && state.remainingTime <= 60 && state.remainingTime > 0
    })

    const progress = computed(() => {
        if (config.duration === 0) return 0
        if (config.countDown) {
            return ((config.duration - state.remainingTime) / config.duration) * 100
        } else {
            return Math.min((state.elapsedTime / config.duration) * 100, 100)
        }
    })

    // Time formatting helpers
    const formatTime = seconds => {
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        const secs = Math.floor(seconds % 60)

        if (hours > 0) {
            return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
        } else {
            return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
        }
    }

    const formatTimeDetailed = seconds => {
        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        const secs = Math.floor(seconds % 60)

        const parts = []
        if (hours > 0) parts.push(`${hours}h`)
        if (minutes > 0) parts.push(`${minutes}m`)
        if (secs > 0 || parts.length === 0) parts.push(`${secs}s`)

        return parts.join(' ')
    }

    const formattedCurrentTime = computed(() => formatTime(currentTime.value))
    const formattedTotalTime = computed(() => formatTime(config.duration))

    // Timer methods
    const startTimer = () => {
        if (state.isCompleted || state.isExpired || state.isActive || state.intervalId) return false

        state.isActive = true
        state.isPaused = false
        state.startTime = state.startTime || Date.now()

        if (state.pauseTime) {
            state.totalPausedTime += Date.now() - state.pauseTime
            state.pauseTime = null
        }

        state.intervalId = setInterval(() => {
            tick()
        }, 1000)

        return true
    }

    const pauseTimer = () => {
        if (!state.isActive || state.isPaused) return false

        state.isActive = false
        state.isPaused = true
        state.pauseTime = Date.now()

        if (state.intervalId) {
            clearInterval(state.intervalId)
            state.intervalId = null
        }

        return true
    }

    const stopTimer = () => {
        state.isActive = false
        state.isPaused = false
        state.isCompleted = true

        if (state.intervalId) {
            clearInterval(state.intervalId)
            state.intervalId = null
        }

        if (config.onComplete && typeof config.onComplete === 'function') {
            config.onComplete({
                elapsedTime: state.elapsedTime,
                remainingTime: state.remainingTime,
                totalTime: config.duration,
            })
        }

        return true
    }

    const resetTimer = () => {
        if (state.intervalId) {
            clearInterval(state.intervalId)
            state.intervalId = null
        }

        state.isActive = false
        state.isPaused = false
        state.isCompleted = false
        state.isExpired = false
        state.startTime = null
        state.pauseTime = null
        state.elapsedTime = 0
        state.remainingTime = config.duration
        state.totalPausedTime = 0

        return true
    }

    const addTime = seconds => {
        const s = Number(seconds)
        if (!Number.isFinite(s) || s <= 0) return false
        config.duration = Math.max(0, (config.duration || 0) + s)
        if (config.countDown) {
            state.remainingTime = Math.max(0, (state.remainingTime || 0) + s)
        }
        return true
    }

    const subtractTime = seconds => {
        const s = Number(seconds)
        if (!Number.isFinite(s) || s <= 0) return false
        const newDuration = Math.max(0, (config.duration || 0) - s)
        let newRemaining = state.remainingTime
        if (config.countDown) {
            newRemaining = Math.max(0, (state.remainingTime || 0) - s)
        }
        config.duration = newDuration
        state.remainingTime = newRemaining

        if (config.countDown && state.remainingTime === 0) {
            expireTimer()
        }
        return true
    }

    const setTime = seconds => {
        const wasActive = state.isActive
        resetTimer()

        config.duration = seconds
        state.remainingTime = seconds

        if (wasActive && config.autoStart) {
            startTimer()
        }
    }

    // Internal tick method
    const tick = () => {
        if (!state.isActive) return

        const now = Date.now()
        const actualElapsed = Math.floor((now - state.startTime - state.totalPausedTime) / 1000)

        state.elapsedTime = actualElapsed

        if (config.countDown) {
            state.remainingTime = Math.max(0, config.duration - actualElapsed)

            if (state.remainingTime === 0) {
                expireTimer()
                return
            }
        } else {
            if (config.duration > 0 && state.elapsedTime >= config.duration) {
                stopTimer()
                return
            }
        }

        // Call onTick callback
        if (config.onTick && typeof config.onTick === 'function') {
            config.onTick({
                elapsedTime: state.elapsedTime,
                remainingTime: state.remainingTime,
                currentTime: currentTime.value,
                isWarningTime: isWarningTime.value,
                isExpiring: isExpiring.value,
            })
        }
    }

    const expireTimer = () => {
        state.isActive = false
        state.isPaused = false
        state.isExpired = true
        state.remainingTime = 0

        if (state.intervalId) {
            clearInterval(state.intervalId)
            state.intervalId = null
        }

        if (config.onExpire && typeof config.onExpire === 'function') {
            config.onExpire({
                elapsedTime: state.elapsedTime,
                totalTime: config.duration,
            })
        }
    }

    // Multiple timer support
    const createSubTimer = subConfig => {
        return useTimer({
            ...config,
            ...subConfig,
        })
    }

    // Persistence helpers
    const getState = () => {
        return {
            elapsedTime: state.elapsedTime,
            remainingTime: state.remainingTime,
            isActive: state.isActive,
            isPaused: state.isPaused,
            isCompleted: state.isCompleted,
            isExpired: state.isExpired,
            startTime: state.startTime,
            totalPausedTime: state.totalPausedTime,
            duration: config.duration,
        }
    }

    const restoreState = savedState => {
        if (!savedState) return false

        state.elapsedTime = savedState.elapsedTime || 0
        state.remainingTime = savedState.remainingTime || config.duration
        state.isCompleted = savedState.isCompleted || false
        state.isExpired = savedState.isExpired || false
        state.startTime = savedState.startTime || null
        state.totalPausedTime = savedState.totalPausedTime || 0
        config.duration = savedState.duration || config.duration

        // Don't restore active/paused state - let user manually resume
        state.isActive = false
        state.isPaused = savedState.isPaused || false

        return true
    }

    // Lifecycle management
    onMounted(() => {
        if (config.autoStart) {
            startTimer()
        }
    })

    onUnmounted(() => {
        if (state.intervalId) {
            clearInterval(state.intervalId)
        }
    })

    // Note: auto-start occurs in onMounted when configured; avoid double start

    return {
        // State
        state: readonly(state),
        config,

        // Computed
        currentTime,
        isWarningTime,
        isExpiring,
        progress,
        formattedCurrentTime,
        formattedTotalTime,

        // Methods
        startTimer,
        pauseTimer,
        stopTimer,
        resetTimer,
        addTime,
        subtractTime,
        setTime,
        formatTime,
        formatTimeDetailed,
        createSubTimer,
        getState,
        restoreState,

        // Getters
        isActive: computed(() => state.isActive),
        isPaused: computed(() => state.isPaused),
        isCompleted: computed(() => state.isCompleted),
        isExpired: computed(() => state.isExpired),
        elapsedTime: computed(() => state.elapsedTime),
        remainingTime: computed(() => state.remainingTime),
    }
}
