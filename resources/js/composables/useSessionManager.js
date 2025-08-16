import { reactive, ref, computed, nextTick } from 'vue'
import { router } from '@inertiajs/vue3'
import { usePage } from '@inertiajs/vue3'

export function useSessionManager(initialConfig = {}) {
    // Session state management
    const session = reactive({
        current_question: 0,
        current_section: 0,
        total_time_taken: 0,
        status: 'active', // active, paused, completed, expired
        answers: {},
        question_status: {}, // answered, not_answered, mark_for_review
        sections: [],
        questions: [],
        auto_save_interval: null, // legacy; will not be used by new loop
        auto_save_timeout: null,
        last_saved: null,
        saveEndpoint: null,
        ...initialConfig,
    })

    const isLoading = ref(false)
    const isSaving = ref(false)
    const error = ref(null)
    const { props } = usePage()

    // Computed properties for session analysis
    const totalQuestions = computed(() => {
        if (session.sections?.length > 0) {
            return session.sections.reduce((total, section) => total + (section.questions?.length || 0), 0)
        }
        return session.questions?.length || 0
    })

    const answeredCount = computed(() => {
        return Object.values(session.question_status).filter(
            status => status === 'answered' || status === 'answered_mark_for_review'
        ).length
    })

    const notAnsweredCount = computed(() => {
        return Object.values(session.question_status).filter(status => status === 'not_answered').length
    })

    const notVisitedCount = computed(() => {
        return Object.values(session.question_status).filter(status => status === 'not_visited').length
    })

    const markedForReviewCount = computed(() => {
        return Object.values(session.question_status).filter(status => status === 'mark_for_review').length
    })

    const progressPercentage = computed(() => {
        if (totalQuestions.value === 0) return 0
        return Math.round((answeredCount.value / totalQuestions.value) * 100)
    })

    // Session management methods
    const updateAnswer = async (questionId, answer, options = {}) => {
        try {
            session.answers[questionId] = answer

            // Update question status based on current state
            const questionIndex = options.questionIndex || session.current_question
            if (session.question_status[questionIndex] === 'mark_for_review') {
                session.question_status[questionIndex] = 'answered_mark_for_review'
            } else {
                session.question_status[questionIndex] = 'answered'
            }

            session.last_saved = new Date()

            // Auto-save if enabled
            if (options.autoSave !== false) {
                await saveSession()
            }

            return { success: true }
        } catch (err) {
            error.value = err.message
            return { success: false, error: err.message }
        }
    }

    const updateQuestionStatus = (questionIndex, status) => {
        session.question_status[questionIndex] = status
    }

    // Unified status setter to keep other navigation stores in sync when provided
    const setStatus = (questionIndex, status, options = {}) => {
        updateQuestionStatus(questionIndex, status)
        const nav = options.navigation
        if (nav && typeof nav.updateQuestionStatus === 'function') {
            nav.updateQuestionStatus(questionIndex, status)
        }
        if (typeof options.onChange === 'function') {
            options.onChange(questionIndex, status)
        }
    }

    const submitAnswer = async (questionId, answer, options = {}) => {
        isLoading.value = true
        error.value = null

        try {
            const endpoint = options.endpoint
            if (!endpoint) {
                throw new Error('submitAnswer requires an explicit endpoint')
            }
            const payload = {
                question_id: questionId,
                answer: answer,
                session_id: session.id,
                time_taken: session.total_time_taken,
                ...options.extraPayload,
            }

            await router.post(endpoint, payload, {
                preserveState: true,
                preserveScroll: true,
                onSuccess: page => {
                    session.answers[questionId] = answer
                    const questionIndex = options.questionIndex || session.current_question
                    if (session.question_status[questionIndex] === 'mark_for_review') {
                        session.question_status[questionIndex] = 'answered_mark_for_review'
                    } else {
                        session.question_status[questionIndex] = 'answered'
                    }

                    // Call custom callback if provided
                    options.onSuccess && typeof options.onSuccess === 'function' && options.onSuccess(page)
                },
            })
            return { success: true }
        } catch (err) {
            error.value = err.message
            return { success: false, error: err.message }
        } finally {
            isLoading.value = false
        }
    }

    const nextQuestion = () => {
        if (session.current_question < totalQuestions.value - 1) {
            session.current_question++
            return true
        }
        return false
    }

    const prevQuestion = () => {
        if (session.current_question > 0) {
            session.current_question--
            return true
        }
        return false
    }

    const jumpToQuestion = questionIndex => {
        if (questionIndex >= 0 && questionIndex < totalQuestions.value) {
            session.current_question = questionIndex
            return true
        }
        return false
    }

    const jumpToSection = sectionIndex => {
        if (sectionIndex >= 0 && sectionIndex < session.sections.length) {
            session.current_section = sectionIndex
            // Jump to first question of the section
            const questionsBeforeSection = session.sections
                .slice(0, sectionIndex)
                .reduce((total, section) => total + (section.questions?.length || 0), 0)
            session.current_question = questionsBeforeSection
            return true
        }
        return false
    }

    const markForReview = (questionIndex, questionId = null) => {
        const currentStatus = session.question_status[questionIndex]
        // prefer explicit questionId from caller; fallback to indexed question code when available
        const qid = questionId || session.questions?.[questionIndex]?.code
        const hasAnswer = qid ? !!session.answers[qid] : false

        if (currentStatus === 'answered_mark_for_review') {
            session.question_status[questionIndex] = 'answered'
        } else if (currentStatus === 'mark_for_review') {
            session.question_status[questionIndex] = hasAnswer ? 'answered' : 'not_answered'
        } else {
            session.question_status[questionIndex] = hasAnswer ? 'answered_mark_for_review' : 'mark_for_review'
        }
    }

    const getCurrentQuestion = computed(() => {
        if (session.sections?.length > 0) {
            let questionIndex = 0
            for (const section of session.sections) {
                if (questionIndex + (section.questions?.length || 0) > session.current_question) {
                    return section.questions[session.current_question - questionIndex]
                }
                questionIndex += section.questions?.length || 0
            }
        }
        return session.questions?.[session.current_question] || null
    })

    const getCurrentSection = computed(() => {
        if (session.sections?.length > 0) {
            return session.sections[session.current_section] || null
        }
        return null
    })

    // Auto-save functionality
    const startAutoSave = (intervalMs = 30000) => {
        // Early return if no save endpoint is configured (e.g., for practice mode)
        if (!session.saveEndpoint) {
            return
        }

        // Clear any legacy intervals
        if (session.auto_save_interval) {
            clearInterval(session.auto_save_interval)
            session.auto_save_interval = null
        }
        // Clear existing timeouts
        if (session.auto_save_timeout) {
            clearTimeout(session.auto_save_timeout)
            session.auto_save_timeout = null
        }

        const loop = async () => {
            try {
                await saveSession()
            } finally {
                // Schedule next run only after save completes
                session.auto_save_timeout = setTimeout(loop, intervalMs)
            }
        }
        // Kick off loop
        session.auto_save_timeout = setTimeout(loop, intervalMs)
    }

    const stopAutoSave = () => {
        if (session.auto_save_interval) {
            clearInterval(session.auto_save_interval)
            session.auto_save_interval = null
        }
        if (session.auto_save_timeout) {
            clearTimeout(session.auto_save_timeout)
            session.auto_save_timeout = null
        }
    }

    const saveSession = async () => {
        if (isSaving.value) {
            return { success: false, error: 'Already saving' }
        }
        // no-op when save endpoint is not provided/configured
        if (!session.saveEndpoint) {
            return { success: true, skipped: true }
        }
        isSaving.value = true
        try {
            await router.post(
                session.saveEndpoint,
                {
                    session_id: session.id,
                    answers: session.answers,
                    question_status: session.question_status,
                    current_question: session.current_question,
                    current_section: session.current_section,
                    total_time_taken: session.total_time_taken,
                    status: session.status,
                },
                {
                    preserveState: true,
                    preserveScroll: true,
                }
            )

            session.last_saved = new Date()
            return { success: true }
        } catch (err) {
            error.value = err.message
            return { success: false, error: err.message }
        } finally {
            isSaving.value = false
        }
    }

    // Session completion
    const completeSession = async (options = {}) => {
        isLoading.value = true
        error.value = null

        try {
            stopAutoSave()
            session.status = 'completed'
            const endpoint = options.endpoint
            if (!endpoint) {
                throw new Error('completeSession requires an explicit endpoint')
            }

            await router.post(endpoint, {
                session_id: session.id,
                answers: session.answers,
                question_status: session.question_status,
                total_time_taken: session.total_time_taken,
                completed_at: new Date().toISOString(),
            })

            return { success: true }
        } catch (err) {
            error.value = err.message
            return { success: false, error: err.message }
        } finally {
            isLoading.value = false
        }
    }

    // Timer integration methods
    const incrementTime = (seconds = 1) => {
        session.total_time_taken += seconds
    }

    const pauseSession = () => {
        session.status = 'paused'
        stopAutoSave()
    }

    const resumeSession = () => {
        session.status = 'active'
        startAutoSave()
    }

    // Session validation
    const validateSession = () => {
        const errors = []

        if (!session.id) {
            errors.push('Session ID is required')
        }

        if (session.status === 'expired') {
            errors.push('Session has expired')
        }

        return {
            isValid: errors.length === 0,
            errors,
        }
    }

    // Cleanup
    const cleanup = () => {
        stopAutoSave()
    }

    return {
        // State
        session,
        isLoading,
        isSaving,
        error,

        // Computed
        totalQuestions,
        answeredCount,
        notAnsweredCount,
        notVisitedCount,
        markedForReviewCount,
        progressPercentage,
        getCurrentQuestion,
        getCurrentSection,

        // Methods
        updateAnswer,
        updateQuestionStatus,
        setStatus,
        submitAnswer,
        nextQuestion,
        prevQuestion,
        jumpToQuestion,
        jumpToSection,
        markForReview,
        startAutoSave,
        stopAutoSave,
        saveSession,
        completeSession,
        incrementTime,
        pauseSession,
        resumeSession,
        validateSession,
        cleanup,
    }
}
