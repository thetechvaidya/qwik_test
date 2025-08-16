import { reactive, computed, ref, unref } from 'vue'
import { sumBy } from 'lodash'

export function useQuestionNavigation(questionsRef, sectionsRef) {
    // Navigation state
    const navigation = reactive({
        viewMode: 'chip', // chip, list, grid
        showStatistics: true,
        filterType: 'all', // all, answered, not_answered, mark_for_review
        searchQuery: '',
        currentPage: 1,
        itemsPerPage: 20,
    })

    const questionStatuses = ref({})

    // Question statistics computed properties
    const totalQuestions = computed(() => {
        const sections = unref(sectionsRef) || []
        const questions = unref(questionsRef) || []
        if (sections.length > 0) {
            return sumBy(sections, section => section.questions?.length || 0)
        }
        return questions.length
    })

    const answeredQuestions = computed(() => {
        return Object.values(questionStatuses.value).filter(status => status === 'answered').length
    })

    const notAnsweredQuestions = computed(() => {
        return Object.values(questionStatuses.value).filter(status => status === 'not_answered').length
    })

    const markedForReviewQuestions = computed(() => {
        return Object.values(questionStatuses.value).filter(status => status === 'mark_for_review').length
    })

    const answeredMarkForReviewQuestions = computed(() => {
        return Object.values(questionStatuses.value).filter(status => status === 'answered_mark_for_review').length
    })

    const notVisitedQuestions = computed(() => {
        return Object.values(questionStatuses.value).filter(status => status === 'not_visited').length
    })

    // Percentage calculations
    const answeredPercentage = computed(() => {
        if (totalQuestions.value === 0) return 0
        return Math.round((answeredQuestions.value / totalQuestions.value) * 100)
    })

    const notAnsweredPercentage = computed(() => {
        if (totalQuestions.value === 0) return 0
        return Math.round((notAnsweredQuestions.value / totalQuestions.value) * 100)
    })

    const markedForReviewPercentage = computed(() => {
        if (totalQuestions.value === 0) return 0
        return Math.round((markedForReviewQuestions.value / totalQuestions.value) * 100)
    })

    // Section-wise statistics
    const sectionStatistics = computed(() => {
        const sections = unref(sectionsRef) || []
        if (sections.length === 0) return []

        return sections.map((section, sectionIndex) => {
            const sectionLength = section.questions?.length || section.total_questions || 0
            let answeredInSection = 0
            let notAnsweredInSection = 0
            let markedInSection = 0

            // Calculate question indices for this section using known counts
            const startIndex = sections.slice(0, sectionIndex).reduce((total, prevSection) => {
                return total + (prevSection.questions?.length || prevSection.total_questions || 0)
            }, 0)

            for (let questionIndex = 0; questionIndex < sectionLength; questionIndex++) {
                const globalIndex = startIndex + questionIndex
                const status = questionStatuses.value[globalIndex]
                if (status === 'answered' || status === 'answered_mark_for_review') answeredInSection++
                else if (status === 'mark_for_review') markedInSection++
                else if (status === 'not_answered' || status === 'not_visited' || !status) notAnsweredInSection++
            }

            return {
                ...section,
                sectionIndex,
                totalQuestions: sectionLength,
                answeredQuestions: answeredInSection,
                notAnsweredQuestions: notAnsweredInSection,
                markedForReviewQuestions: markedInSection,
                answeredPercentage: sectionLength > 0 ? Math.round((answeredInSection / sectionLength) * 100) : 0,
                notAnsweredPercentage: sectionLength > 0 ? Math.round((notAnsweredInSection / sectionLength) * 100) : 0,
                markedForReviewPercentage: sectionLength > 0 ? Math.round((markedInSection / sectionLength) * 100) : 0,
            }
        })
    })

    // Filtered questions based on current filter
    const filteredQuestions = computed(() => {
        const sections = unref(sectionsRef) || []
        const questions = unref(questionsRef) || []
        let allQuestions = []

        // Build complete questions list with indices
        if (sections.length > 0) {
            sections.forEach((section, sectionIndex) => {
                const sectionQuestions = section.questions || []
                const startIndex = sections.slice(0, sectionIndex).reduce((total, prevSection) => {
                    return total + (prevSection.questions?.length || 0)
                }, 0)

                sectionQuestions.forEach((question, questionIndex) => {
                    allQuestions.push({
                        ...question,
                        globalIndex: startIndex + questionIndex,
                        sectionIndex,
                        questionIndex,
                        sectionName: section.name,
                        status: questionStatuses.value[startIndex + questionIndex] || 'not_visited',
                    })
                })
            })
        } else {
            allQuestions = questions.map((question, index) => ({
                ...question,
                globalIndex: index,
                sectionIndex: 0,
                questionIndex: index,
                status: questionStatuses.value[index] || 'not_visited',
            }))
        }

        // Apply search filter
        if (navigation.searchQuery) {
            const query = navigation.searchQuery.toLowerCase()
            allQuestions = allQuestions.filter(question => {
                return (
                    question.title?.toLowerCase().includes(query) ||
                    question.question?.toLowerCase().includes(query) ||
                    question.sectionName?.toLowerCase().includes(query) ||
                    (question.globalIndex + 1).toString().includes(query)
                )
            })
        }

        // Apply status filter
        if (navigation.filterType !== 'all') {
            allQuestions = allQuestions.filter(question => {
                return question.status === navigation.filterType
            })
        }

        return allQuestions
    })

    // Paginated questions for list view
    const paginatedQuestions = computed(() => {
        const startIndex = (navigation.currentPage - 1) * navigation.itemsPerPage
        const endIndex = startIndex + navigation.itemsPerPage
        return filteredQuestions.value.slice(startIndex, endIndex)
    })

    const totalPages = computed(() => {
        return Math.ceil(filteredQuestions.value.length / navigation.itemsPerPage)
    })

    // Navigation methods
    const setViewMode = mode => {
        navigation.viewMode = mode
    }

    const setFilterType = type => {
        navigation.filterType = type
        navigation.currentPage = 1 // Reset to first page when filtering
    }

    const setSearchQuery = query => {
        navigation.searchQuery = query
        navigation.currentPage = 1 // Reset to first page when searching
    }

    const goToPage = page => {
        if (page >= 1 && page <= totalPages.value) {
            navigation.currentPage = page
            return true
        }
        return false
    }

    const nextPage = () => {
        return goToPage(navigation.currentPage + 1)
    }

    const prevPage = () => {
        return goToPage(navigation.currentPage - 1)
    }

    // Question status management
    const updateQuestionStatus = (questionIndex, status) => {
        questionStatuses.value[questionIndex] = status
    }

    const getQuestionStatus = questionIndex => {
        return questionStatuses.value[questionIndex] || 'not_visited'
    }

    const toggleMarkForReview = (questionIndex, hasAnswer = false) => {
        const current = questionStatuses.value[questionIndex]
        switch (current) {
            case 'answered_mark_for_review':
                questionStatuses.value[questionIndex] = 'answered'
                break
            case 'mark_for_review':
                questionStatuses.value[questionIndex] = hasAnswer ? 'answered' : 'not_answered'
                break
            case 'answered':
                questionStatuses.value[questionIndex] = 'answered_mark_for_review'
                break
            case 'not_answered':
            case 'not_visited':
            default:
                questionStatuses.value[questionIndex] = hasAnswer ? 'answered_mark_for_review' : 'mark_for_review'
                break
        }
    }

    // Bulk operations
    const markAllAsReviewed = () => {
        Object.keys(questionStatuses.value).forEach(key => {
            if (questionStatuses.value[key] === 'mark_for_review') {
                questionStatuses.value[key] = 'answered'
            }
        })
    }

    const clearAllMarkers = () => {
        Object.keys(questionStatuses.value).forEach(key => {
            if (questionStatuses.value[key] === 'mark_for_review') {
                questionStatuses.value[key] = 'not_answered'
            }
        })
    }

    // Question jumping with validation
    const jumpToQuestion = (questionIndex, callback) => {
        if (questionIndex >= 0 && questionIndex < totalQuestions.value) {
            if (callback && typeof callback === 'function') {
                callback(questionIndex)
            }
            return true
        }
        return false
    }

    // Removed chip helpers; chips handle their own styling/icons

    // Initialize question statuses
    const initializeStatuses = (initialStatuses = {}) => {
        questionStatuses.value = { ...initialStatuses }
    }

    // Reset navigation state
    const resetNavigation = () => {
        navigation.viewMode = 'chip'
        navigation.filterType = 'all'
        navigation.searchQuery = ''
        navigation.currentPage = 1
        questionStatuses.value = {}
    }

    return {
        // State
        navigation,
        questionStatuses,

        // Computed properties
        totalQuestions,
        answeredQuestions,
        notAnsweredQuestions,
        markedForReviewQuestions,
        answeredMarkForReviewQuestions,
        notVisitedQuestions,
        answeredPercentage,
        notAnsweredPercentage,
        markedForReviewPercentage,
        sectionStatistics,
        filteredQuestions,
        paginatedQuestions,
        totalPages,

        // Methods
        setViewMode,
        setFilterType,
        setSearchQuery,
        goToPage,
        nextPage,
        prevPage,
        updateQuestionStatus,
        getQuestionStatus,
        toggleMarkForReview,
        markAllAsReviewed,
        clearAllMarkers,
        jumpToQuestion,
        initializeStatuses,
        resetNavigation,
    }
}
