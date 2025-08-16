<!DOCTYPE html>
<html dir="<?php echo e(app(\App\Settings\LocalizationSettings::class)->default_direction); ?>" lang="<?php echo e(str_replace('_', '-', app()->getLocale())); ?>">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">

    <title><?php echo $__env->yieldContent('title'); ?> - <?php echo e(config('app.name', 'QwikTest')); ?></title>
    <meta name="description" content="<?php echo e(app(\App\Settings\SiteSettings::class)->seo_description); ?>">
    <link rel="icon" href="<?php echo e(url('storage/'.app(\App\Settings\SiteSettings::class)->favicon_path)); ?>">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="<?php echo e(config('qwiktest.default_font_url')); ?>">

    <!-- Styles -->
    <?php if(app()->environment('testing')): ?>
        <link rel="stylesheet" href="<?php echo e(asset('css/store.css')); ?>">
    <?php else: ?>
        <?php echo app('Illuminate\Foundation\Vite')('resources/css/store.css'); ?>
    <?php endif; ?>
    <style>
        :root {
            /* Custom Theme Configuration */
            --custom-font: "<?php echo e(config('qwiktest.default_font')); ?>";
            --primary-color: <?php echo e('#'.app(\App\Settings\ThemeSettings::class)->primary_color); ?>;
            --secondary-color: <?php echo e('#'.app(\App\Settings\ThemeSettings::class)->secondary_color); ?>;
        }
    </style>
    <?php echo $__env->yieldPushContent('styles'); ?>
    <!-- Scripts -->
    <script src="<?php echo e(asset('vendor/alpinejs/alpine.min.js')); ?>" defer></script>
</head>
<body class="font-sans antialiased bg-white dark:bg-black">
    <!--TopBar-->
    <?php if (isset($component)) { $__componentOriginal43c4c011cda05ea8cd4b9e67ae722640 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal43c4c011cda05ea8cd4b9e67ae722640 = $attributes; } ?>
<?php $component = App\View\Components\TopBar::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('top-bar'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\TopBar::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal43c4c011cda05ea8cd4b9e67ae722640)): ?>
<?php $attributes = $__attributesOriginal43c4c011cda05ea8cd4b9e67ae722640; ?>
<?php unset($__attributesOriginal43c4c011cda05ea8cd4b9e67ae722640); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal43c4c011cda05ea8cd4b9e67ae722640)): ?>
<?php $component = $__componentOriginal43c4c011cda05ea8cd4b9e67ae722640; ?>
<?php unset($__componentOriginal43c4c011cda05ea8cd4b9e67ae722640); ?>
<?php endif; ?>
    <!--NavBar-->
    <?php if (isset($component)) { $__componentOriginalb9eddf53444261b5c229e9d8b9f1298e = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginalb9eddf53444261b5c229e9d8b9f1298e = $attributes; } ?>
<?php $component = App\View\Components\Navbar::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('navbar'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Navbar::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginalb9eddf53444261b5c229e9d8b9f1298e)): ?>
<?php $attributes = $__attributesOriginalb9eddf53444261b5c229e9d8b9f1298e; ?>
<?php unset($__attributesOriginalb9eddf53444261b5c229e9d8b9f1298e); ?>
<?php endif; ?>
<?php if (isset($__componentOriginalb9eddf53444261b5c229e9d8b9f1298e)): ?>
<?php $component = $__componentOriginalb9eddf53444261b5c229e9d8b9f1298e; ?>
<?php unset($__componentOriginalb9eddf53444261b5c229e9d8b9f1298e); ?>
<?php endif; ?>
    <?php echo $__env->yieldContent('content'); ?>
    <!--Footer-->
    <?php if (isset($component)) { $__componentOriginal99051027c5120c83a2f9a5ae7c4c3cfa = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal99051027c5120c83a2f9a5ae7c4c3cfa = $attributes; } ?>
<?php $component = App\View\Components\Footer::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('footer'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Footer::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal99051027c5120c83a2f9a5ae7c4c3cfa)): ?>
<?php $attributes = $__attributesOriginal99051027c5120c83a2f9a5ae7c4c3cfa; ?>
<?php unset($__attributesOriginal99051027c5120c83a2f9a5ae7c4c3cfa); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal99051027c5120c83a2f9a5ae7c4c3cfa)): ?>
<?php $component = $__componentOriginal99051027c5120c83a2f9a5ae7c4c3cfa; ?>
<?php unset($__componentOriginal99051027c5120c83a2f9a5ae7c4c3cfa); ?>
<?php endif; ?>
<?php echo $__env->yieldPushContent('scripts'); ?>
</body>
</html>
<?php /**PATH C:\Users\rakhi\Desktop\Trie\resources\views/store/layout.blade.php ENDPATH**/ ?>