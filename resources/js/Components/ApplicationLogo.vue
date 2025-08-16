<template>
    <a :href="route('welcome')">
        <img
            :src="$page.props.assetUrl + $page.props.general.logo_path"
            :alt="$page.props.general.app_name"
            class="h-12"
        />
    </a>
</template>

<script setup>
// This component doesn't need any script logic
</script>
