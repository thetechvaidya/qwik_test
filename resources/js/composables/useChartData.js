import { reactive, computed, ref, readonly } from 'vue'

export function useChartData() {
    // Chart configuration and data state
    const chartData = reactive({
        doughnut: {},
        bar: {},
        line: {},
        radar: {},
    })

    const chartOptions = reactive({
        doughnut: {},
        bar: {},
        line: {},
        radar: {},
    })

    const isLoading = ref(false)
    const error = ref(null)

    // Color schemes for consistent styling
    const colorSchemes = {
        primary: ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#06B6D4', '#84CC16', '#F97316'],
        success: ['#10B981', '#34D399', '#6EE7B7', '#A7F3D0', '#D1FAE5'],
        warning: ['#F59E0B', '#FBBF24', '#FCD34D', '#FDE68A', '#FEF3C7'],
        danger: ['#EF4444', '#F87171', '#FCA5A5', '#FECACA', '#FEE2E2'],
        info: ['#3B82F6', '#60A5FA', '#93C5FD', '#DBEAFE', '#EFF6FF'],
    }

    // Doughnut chart helpers
    const createDoughnutChart = (data, options = {}) => {
        const defaultOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        padding: 20,
                    },
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const label = context.label || ''
                            const value = context.parsed
                            const total = context.dataset.data.reduce((sum, val) => sum + val, 0)
                            const percentage = total > 0 ? Math.round((value / total) * 100) : 0
                            return `${label}: ${value} (${percentage}%)`
                        },
                    },
                },
            },
            cutout: '60%',
        }

        chartData.doughnut = {
            labels: data.labels || [],
            datasets: [
                {
                    data: data.values || [],
                    backgroundColor: data.colors || colorSchemes.primary,
                    borderWidth: 2,
                    borderColor: '#ffffff',
                },
            ],
        }

        chartOptions.doughnut = {
            ...defaultOptions,
            ...options,
        }

        return {
            data: chartData.doughnut,
            options: chartOptions.doughnut,
        }
    }

    // Bar chart helpers
    const createBarChart = (data, options = {}) => {
        const defaultOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: data.datasets?.length > 1,
                    position: 'top',
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                },
            },
            scales: {
                x: {
                    grid: {
                        display: false,
                    },
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)',
                    },
                },
            },
        }

        chartData.bar = {
            labels: data.labels || [],
            datasets:
                data.datasets?.map((dataset, index) => ({
                    label: dataset.label,
                    data: dataset.data,
                    backgroundColor:
                        dataset.backgroundColor || colorSchemes.primary[index % colorSchemes.primary.length],
                    borderColor: dataset.borderColor || colorSchemes.primary[index % colorSchemes.primary.length],
                    borderWidth: 1,
                })) || [],
        }

        chartOptions.bar = {
            ...defaultOptions,
            ...options,
        }

        return {
            data: chartData.bar,
            options: chartOptions.bar,
        }
    }

    // Line chart helpers
    const createLineChart = (data, options = {}) => {
        const defaultOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: data.datasets?.length > 1,
                    position: 'top',
                },
                tooltip: {
                    mode: 'index',
                    intersect: false,
                },
            },
            scales: {
                x: {
                    grid: {
                        display: false,
                    },
                },
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)',
                    },
                },
            },
            elements: {
                point: {
                    radius: 4,
                    hoverRadius: 6,
                },
                line: {
                    tension: 0.3,
                },
            },
        }

        chartData.line = {
            labels: data.labels || [],
            datasets:
                data.datasets?.map((dataset, index) => ({
                    label: dataset.label,
                    data: dataset.data,
                    borderColor: dataset.borderColor || colorSchemes.primary[index % colorSchemes.primary.length],
                    backgroundColor:
                        dataset.backgroundColor || `${colorSchemes.primary[index % colorSchemes.primary.length]}20`,
                    borderWidth: 2,
                    fill: dataset.fill !== false,
                })) || [],
        }

        chartOptions.line = {
            ...defaultOptions,
            ...options,
        }

        return {
            data: chartData.line,
            options: chartOptions.line,
        }
    }

    // Radar chart helpers
    const createRadarChart = (data, options = {}) => {
        const defaultOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: data.datasets?.length > 1,
                    position: 'top',
                },
            },
            scales: {
                r: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)',
                    },
                    angleLines: {
                        color: 'rgba(0, 0, 0, 0.1)',
                    },
                },
            },
        }

        chartData.radar = {
            labels: data.labels || [],
            datasets:
                data.datasets?.map((dataset, index) => ({
                    label: dataset.label,
                    data: dataset.data,
                    borderColor: dataset.borderColor || colorSchemes.primary[index % colorSchemes.primary.length],
                    backgroundColor:
                        dataset.backgroundColor || `${colorSchemes.primary[index % colorSchemes.primary.length]}20`,
                    borderWidth: 2,
                    pointBackgroundColor:
                        dataset.pointBackgroundColor || colorSchemes.primary[index % colorSchemes.primary.length],
                })) || [],
        }

        chartOptions.radar = {
            ...defaultOptions,
            ...options,
        }

        return {
            data: chartData.radar,
            options: chartOptions.radar,
        }
    }

    // Data transformation utilities
    const transformExamResults = examData => {
        if (!examData) return null

        const sections = examData.sections || []
        const sectionNames = sections.map(section => section.name)
        const sectionScores = sections.map(section => section.score || 0)
        const sectionMaxScores = sections.map(section => section.max_score || 0)

        return {
            sectionPerformance: {
                labels: sectionNames,
                datasets: [
                    {
                        label: 'Your Score',
                        data: sectionScores,
                        backgroundColor: colorSchemes.primary[0],
                    },
                    {
                        label: 'Max Score',
                        data: sectionMaxScores,
                        backgroundColor: colorSchemes.primary[1],
                    },
                ],
            },
            overallPerformance: {
                labels: ['Correct', 'Incorrect', 'Unanswered'],
                values: [
                    examData.correct_answers || 0,
                    examData.incorrect_answers || 0,
                    examData.unanswered_questions || 0,
                ],
                colors: [colorSchemes.success[0], colorSchemes.danger[0], colorSchemes.warning[0]],
            },
        }
    }

    const transformQuizResults = quizData => {
        if (!quizData) return null

        return {
            performance: {
                labels: ['Correct', 'Incorrect'],
                values: [quizData.correct_answers || 0, quizData.incorrect_answers || 0],
                colors: [colorSchemes.success[0], colorSchemes.danger[0]],
            },
            timeAnalysis: {
                labels: quizData.questions?.map((_, index) => `Q${index + 1}`) || [],
                datasets: [
                    {
                        label: 'Time Taken (seconds)',
                        data: quizData.questions?.map(q => q.time_taken || 0) || [],
                        borderColor: colorSchemes.info[0],
                        backgroundColor: `${colorSchemes.info[0]}20`,
                    },
                ],
            },
        }
    }

    const transformPracticeAnalysis = practiceData => {
        if (!practiceData) return null

        const subjects = practiceData.subjects || []
        const subjectNames = subjects.map(subject => subject.name)
        const accuracy = subjects.map(subject => subject.accuracy || 0)
        const timeSpent = subjects.map(subject => subject.time_spent || 0)

        return {
            accuracyBySubject: {
                labels: subjectNames,
                datasets: [
                    {
                        label: 'Accuracy (%)',
                        data: accuracy,
                        backgroundColor: colorSchemes.success,
                    },
                ],
            },
            timeDistribution: {
                labels: subjectNames,
                values: timeSpent,
                colors: colorSchemes.primary,
            },
            progressTrend: {
                labels: practiceData.daily_progress?.map(day => day.date) || [],
                datasets: [
                    {
                        label: 'Questions Solved',
                        data: practiceData.daily_progress?.map(day => day.questions_solved) || [],
                        borderColor: colorSchemes.primary[0],
                        backgroundColor: `${colorSchemes.primary[0]}20`,
                    },
                ],
            },
        }
    }

    // Responsive chart sizing
    const getResponsiveHeight = (chartType, containerWidth) => {
        const baseHeights = {
            doughnut: 300,
            bar: 400,
            line: 350,
            radar: 350,
        }

        const mobileHeights = {
            doughnut: 250,
            bar: 300,
            line: 280,
            radar: 280,
        }

        return containerWidth < 768 ? mobileHeights[chartType] : baseHeights[chartType]
    }

    // Chart update methods
    const updateChart = (chartType, newData, newOptions = {}) => {
        if (!chartData[chartType]) return false

        // Update data
        Object.assign(chartData[chartType], newData)

        // Update options
        if (newOptions) {
            Object.assign(chartOptions[chartType], newOptions)
        }

        return true
    }

    const refreshChart = chartType => {
        // Force reactivity update
        const currentData = { ...chartData[chartType] }
        chartData[chartType] = currentData
        return true
    }

    // Export/download helpers
    const exportChartAsImage = (chartRef, filename = 'chart') => {
        if (!chartRef || !chartRef.chart) return false

        try {
            const canvas = chartRef.chart.canvas
            const url = canvas.toDataURL('image/png')
            const link = document.createElement('a')
            link.download = `${filename}.png`
            link.href = url
            link.click()
            return true
        } catch (err) {
            error.value = err.message
            return false
        }
    }

    // Accessibility helpers
    const getChartAriaLabel = (chartType, data) => {
        if (!data) return `${chartType} chart`

        const totalDataPoints = Array.isArray(data.datasets)
            ? data.datasets.reduce((total, dataset) => total + (dataset.data?.length || 0), 0)
            : data.values?.length || 0

        return `${chartType} chart with ${totalDataPoints} data points`
    }

    // Computed properties
    const hasChartData = computed(() => {
        return Object.values(chartData).some(data => Object.keys(data).length > 0)
    })

    const chartSummary = computed(() => {
        const summary = {}
        Object.keys(chartData).forEach(type => {
            if (chartData[type].labels || chartData[type].datasets) {
                summary[type] = {
                    labels: chartData[type].labels?.length || 0,
                    datasets: chartData[type].datasets?.length || 0,
                }
            }
        })
        return summary
    })

    return {
        // State
        chartData,
        chartOptions,
        isLoading,
        error,

        // Color schemes
        colorSchemes,

        // Chart creation methods
        createDoughnutChart,
        createBarChart,
        createLineChart,
        createRadarChart,

        // Data transformation methods
        transformExamResults,
        transformQuizResults,
        transformPracticeAnalysis,

        // Utility methods
        getResponsiveHeight,
        updateChart,
        refreshChart,
        exportChartAsImage,
        getChartAriaLabel,

        // Computed
        hasChartData,
        chartSummary,
    }
}
