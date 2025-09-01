<template>
    <div class="comprehension-options">
        <div class="w-full flex flex-col mb-6">
            <label class="pb-2 text-sm font-semibold text-gray-800">{{ translate('Comprehension Passage') }}</label>
            <v-select
                id="comprehension_id"
                v-model="comprehensionId"
                :options="comprehensions"
                :reduce="comprehension => comprehension.id"
                label="title"
                placeholder="Select Comprehension"
                :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                @input="selectComprehension"
                @search="searchComprehensions"
            >
                <template #no-options="{ search, searching }">
                    <span v-if="searching">{{ translate('No results were found for this search') }}.</span>
                    <em v-else class="opacity-50">{{ translate('Start typing to search') }}.</em>
                </template>
            </v-select>
        </div>
    </div>
</template>
<script>
import { useTranslate } from '@/composables/useTranslate';
export default {
    name: 'ComprehensionOptions',
    setup() {
        const { __ } = useTranslate();
        return { translate: __ };
    },
    props: {
        parentComprehensions: Array,
        parentComprehensionId: Number,
    },
    data: function () {
        return {
            comprehensions: this.parentComprehensions,
            comprehensionId: this.parentComprehensionId,
            debounce: null,
        }
    },
    methods: {
        searchComprehensions(search, loading) {
            if (search !== '') {
                let _this = this
                loading(true)
                clearTimeout(this.debounce)
                _this.comprehensions = []
                this.debounce = setTimeout(() => {
                    axios
                        .get(route('search_comprehensions', { query: search }))
                        .then(function (response) {
                            _this.comprehensions = response.data.comprehensions
                        })
                        .catch(function (error) {
                            loading(false)
                        })
                        .then(function () {
                            loading(false)
                        })
                }, 600)
            }
        },
        selectComprehension(event) {
            this.$emit('modifyComprehension', this.comprehensionId)
        },
    },
}
</script>
