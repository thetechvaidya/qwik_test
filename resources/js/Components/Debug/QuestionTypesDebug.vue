<template>
    <div v-if="showDebug" class="fixed bottom-4 right-4 z-50">
        <div class="bg-yellow-50 border border-yellow-200 rounded-lg p-4 shadow-lg max-w-sm">
            <div class="flex items-center justify-between mb-3">
                <h3 class="text-sm font-semibold text-yellow-800">Question Types Debug</h3>
                <button @click="showDebug = false" class="text-yellow-600 hover:text-yellow-800">
                    <i class="pi pi-times text-xs"></i>
                </button>
            </div>
            
            <div class="text-xs text-yellow-700 space-y-2">
                <div>
                    <strong>Count:</strong> {{ questionTypes?.length || 0 }}
                </div>
                <div v-if="questionTypes?.length > 0">
                    <strong>First type:</strong> {{ questionTypes[0]?.name || questionTypes[0]?.text }}
                </div>
                <div v-else class="text-red-600">
                    <strong>Issue:</strong> No question types found
                </div>
                
                <div class="pt-2 border-t border-yellow-200">
                    <button 
                        @click="checkDatabase" 
                        class="text-xs bg-yellow-600 text-white px-2 py-1 rounded hover:bg-yellow-700 mr-2"
                    >
                        Check DB
                    </button>
                    <button 
                        @click="createDefaults" 
                        class="text-xs bg-green-600 text-white px-2 py-1 rounded hover:bg-green-700"
                    >
                        Create Defaults
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Debug Toggle Button -->
    <button 
        v-if="!showDebug && isDev"
        @click="showDebug = true"
        class="fixed bottom-4 right-4 z-40 bg-yellow-500 text-white p-2 rounded-full shadow-lg hover:bg-yellow-600"
        title="Debug Question Types"
    >
        <i class="pi pi-bug text-sm"></i>
    </button>
</template>

<script setup>
import { ref, computed } from 'vue'
import { router } from '@inertiajs/vue3'
import { useToast } from 'primevue/usetoast'

const props = defineProps({
    questionTypes: {
        type: Array,
        default: () => []
    }
})

const toast = useToast()
const showDebug = ref(false)

const isDev = computed(() => import.meta.env.DEV)

const checkDatabase = async () => {
    try {
        const response = await fetch('/api/debug/question-types')
        const data = await response.json()
        
        toast.add({
            severity: 'info',
            summary: 'Database Check',
            detail: `Found ${data.count} question types in database`,
            life: 3000
        })
        
        console.log('Question Types from DB:', data)
    } catch (error) {
        toast.add({
            severity: 'error',
            summary: 'Database Error',
            detail: 'Failed to check database',
            life: 3000
        })
    }
}

const createDefaults = async () => {
    try {
        const response = await fetch('/api/debug/create-default-question-types', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
            }
        })
        
        const data = await response.json()
        
        toast.add({
            severity: 'success',
            summary: 'Success',
            detail: `Created ${data.created} default question types`,
            life: 3000
        })
        
        // Refresh the page to see new question types
        setTimeout(() => {
            window.location.reload()
        }, 1000)
        
    } catch (error) {
        toast.add({
            severity: 'error',
            summary: 'Creation Error',
            detail: 'Failed to create default question types',
            life: 3000
        })
    }
}
</script>
</template>