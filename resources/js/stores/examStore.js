import { defineStore } from 'pinia'
import axios from 'axios'

export const useExamStore = defineStore('exam', {
    state: () => ({
        examPatterns: [],
        subCategories: [],
        details: {
            title: '',
            description: '',
            sub_category_id: '',
            exam_type: 1,
            exam_pattern_id: '',
            is_paid: false,
            price: null,
            schedule_type: 1,
            schedule_from: '',
            schedule_to: '',
            is_public: true,
            is_active: true,
        },
        pattern: {
            auto_duration: false,
            total_duration: null,
            auto_grading: false,
            total_marks: null,
            is_section_based: false,
            disable_section_navigation: false,
            has_section_cutoff: false,
            has_negative_marking: false,
            negative_marking_type: 'fixed',
            negative_marks: null,
        },
        settings: {
            restrict_attempts: false,
            no_of_attempts: null,
            auto_evaluation: true,
            has_partial_weighting: false,
            disable_question_navigation: false,
            list_questions: false,
            show_marks: true,
            allow_calculator: false,
            allow_instant_score_view: true,
            allow_review: true,
            send_email: false,
            enable_face_verification: false,
            enable_id_proof_verification: false,
            enable_image_proctoring: false,
            image_capture_interval: 60,
            suspend_on_tab_shift: false,
            max_shifting_alerts: 3,
        },
        questions: [],
        users: [],
        sections: [
            {
                section_id: null,
                section_duration: null,
                section_marks: null,
                section_cutoff: null,
                section_order: 1,
            },
        ],
        examTypes: [
            { name: 'Objective', code: 1 },
            { name: 'Subjective', code: 2 },
            { name: 'Mixed (Objective & Subjective)', code: 3 },
        ],
        scheduleTypes: [
            { name: 'Fixed', code: 1 },
            { name: 'Flexible', code: 2 },
        ],
        visibilityTypes: [
            { name: 'Public', code: true },
            { name: 'Private', code: false },
        ],
        pricingTypes: [
            { name: 'Free', code: false },
            { name: 'Paid', code: true },
        ],
        autoModes: [
            { name: 'Auto', code: true },
            { name: 'Manual', code: false },
        ],
        choices: [
            { name: 'Yes', code: true },
            { name: 'No', code: false },
        ],
        amountTypes: [
            { name: 'Fixed', code: 'fixed' },
            { name: 'Percentage', code: 'percentage' },
        ],
        en: {
            firstDayOfWeek: 0,
            dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
            dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            dayNamesMin: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            monthNames: [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December',
            ],
            monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            today: 'Today',
            clear: 'Clear',
            dateFormat: 'mm/dd/yy',
            weekHeader: 'Wk',
        },
        debounce: null,
        isLoading: false,
        error: null,
    }),

    getters: {
        allExamPatterns: state => state.examPatterns,
        allSubCategories: state => state.subCategories,
    },

    actions: {
        // Direct state mutation actions (replacing Vuex mutations)
        updateExamPatterns(patterns) {
            this.examPatterns = patterns
        },

        updateSubCategories(categories) {
            this.subCategories = categories
        },

        updateDetails(payload) {
            Object.assign(this.details, payload)
        },

        updatePattern(payload) {
            Object.assign(this.pattern, payload)
        },

        updateSettings(payload) {
            Object.assign(this.settings, payload)
        },

        addSection(payload = null) {
            const newSection = payload || {
                section_id: null,
                section_duration: null,
                section_marks: null,
                section_cutoff: null,
                section_order: this.sections.length + 1,
            }
            this.sections.push(newSection)
        },

        removeSection(index) {
            this.sections.splice(index, 1)
        },

        updateSection(payload) {
            Object.assign(this.sections[payload.index], { [payload.field]: payload.value })
        },

        setLoading(status) {
            this.isLoading = status
        },

        setError(error) {
            this.error = error
        },

        clearError() {
            this.error = null
        },

        // Async actions (replacing Vuex actions)
        async searchSubCategories(query) {
            try {
                if (!window.route) {
                    throw new Error('Route helper unavailable')
                }

                clearTimeout(this.debounce)
                this.updateSubCategories([])
                this.setLoading(true)
                this.clearError()

                this.debounce = setTimeout(async () => {
                    try {
                        const response = await axios.get(window.route('search_sub_categories', { query: query }))
                        this.updateSubCategories(response.data.subCategories)
                    } catch (error) {
                        console.error('Error searching sub categories:', error)
                        this.setError('Failed to search sub categories')
                    } finally {
                        this.setLoading(false)
                    }
                }, 600)
            } catch (error) {
                console.error('Error in searchSubCategories:', error)
                this.setError('Failed to search sub categories')
                this.setLoading(false)
            }
        },

        changeExamType(value) {
            this.updateDetails({ exam_type: value })
            if (value !== 1) {
                this.updateSettings({ auto_evaluation: false })
            }
        },

        // Reset store to initial state
        resetStore() {
            this.examPatterns = []
            this.subCategories = []
            this.details = {
                title: '',
                description: '',
                sub_category_id: '',
                exam_type: 1,
                exam_pattern_id: '',
                is_paid: false,
                price: null,
                schedule_type: 1,
                schedule_from: '',
                schedule_to: '',
                is_public: true,
                is_active: true,
            }
            this.pattern = {
                auto_duration: false,
                total_duration: null,
                auto_grading: false,
                total_marks: null,
                is_section_based: false,
                disable_section_navigation: false,
                has_section_cutoff: false,
                has_negative_marking: false,
                negative_marking_type: 'fixed',
                negative_marks: null,
            }
            this.settings = {
                restrict_attempts: false,
                no_of_attempts: null,
                auto_evaluation: true,
                has_partial_weighting: false,
                disable_question_navigation: false,
                list_questions: false,
                show_marks: true,
                allow_calculator: false,
                allow_instant_score_view: true,
                allow_review: true,
                send_email: false,
                enable_face_verification: false,
                enable_id_proof_verification: false,
                enable_image_proctoring: false,
                image_capture_interval: 60,
                suspend_on_tab_shift: false,
                max_shifting_alerts: 3,
            }
            this.questions = []
            this.users = []
            this.sections = [
                {
                    section_id: null,
                    section_duration: null,
                    section_marks: null,
                    section_cutoff: null,
                    section_order: 1,
                },
            ]
            this.debounce = null
            this.isLoading = false
            this.error = null
        },
    },
})
