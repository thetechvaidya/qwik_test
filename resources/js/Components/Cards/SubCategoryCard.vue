<template>
    <div class="card w-full cursor-pointer hover:shadow-lg">
        <Link :href="route('practice_skills', {category: category.slug})">
            <div class="card-body h-28 flex flex-col justify-center items-center">
                <div class="font-semibold mb-2">{{ category.name }}
                <div class="flex items-center justify-center bg-green-100 rounded">
                    <p class="text-xs leading-loose text-center text-green-700 px-2">{{ category.category }} {{ category.type }}</p>
                </div>
            </div>
        </Link>
    </template>
<script>
    import { Link } from "@inertiajs/vue3"

    export default {
        name: 'SubCategoryCard',
        components: { Link },
        props: {
            category: Object
        }
    }
</script>
