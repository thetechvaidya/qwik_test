<?php $__env->startSection('title', $siteSettings->tag_line); ?>

<?php $__env->startSection('content'); ?>
    <!--Hero-->
    <?php if($homePageSettings->enable_hero): ?>
        <?php if (isset($component)) { $__componentOriginal20742eb2771d985bdc9eeee85f5ff6b5 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal20742eb2771d985bdc9eeee85f5ff6b5 = $attributes; } ?>
<?php $component = App\View\Components\Hero::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('hero'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Hero::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal20742eb2771d985bdc9eeee85f5ff6b5)): ?>
<?php $attributes = $__attributesOriginal20742eb2771d985bdc9eeee85f5ff6b5; ?>
<?php unset($__attributesOriginal20742eb2771d985bdc9eeee85f5ff6b5); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal20742eb2771d985bdc9eeee85f5ff6b5)): ?>
<?php $component = $__componentOriginal20742eb2771d985bdc9eeee85f5ff6b5; ?>
<?php unset($__componentOriginal20742eb2771d985bdc9eeee85f5ff6b5); ?>
<?php endif; ?>
    <?php endif; ?>

    <!--Features-->
    <?php if($homePageSettings->enable_features): ?>
        <?php if (isset($component)) { $__componentOriginal4d5d2495d4f761c086c82a2e66994c4c = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal4d5d2495d4f761c086c82a2e66994c4c = $attributes; } ?>
<?php $component = App\View\Components\Features::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('features'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Features::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal4d5d2495d4f761c086c82a2e66994c4c)): ?>
<?php $attributes = $__attributesOriginal4d5d2495d4f761c086c82a2e66994c4c; ?>
<?php unset($__attributesOriginal4d5d2495d4f761c086c82a2e66994c4c); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal4d5d2495d4f761c086c82a2e66994c4c)): ?>
<?php $component = $__componentOriginal4d5d2495d4f761c086c82a2e66994c4c; ?>
<?php unset($__componentOriginal4d5d2495d4f761c086c82a2e66994c4c); ?>
<?php endif; ?>
    <?php endif; ?>

    <!--Categories-->
    <?php if($homePageSettings->enable_categories): ?>
        <?php if (isset($component)) { $__componentOriginale9cf3a09d119cd486b24945c13b596e5 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginale9cf3a09d119cd486b24945c13b596e5 = $attributes; } ?>
<?php $component = App\View\Components\Categories::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('categories'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Categories::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginale9cf3a09d119cd486b24945c13b596e5)): ?>
<?php $attributes = $__attributesOriginale9cf3a09d119cd486b24945c13b596e5; ?>
<?php unset($__attributesOriginale9cf3a09d119cd486b24945c13b596e5); ?>
<?php endif; ?>
<?php if (isset($__componentOriginale9cf3a09d119cd486b24945c13b596e5)): ?>
<?php $component = $__componentOriginale9cf3a09d119cd486b24945c13b596e5; ?>
<?php unset($__componentOriginale9cf3a09d119cd486b24945c13b596e5); ?>
<?php endif; ?>
    <?php endif; ?>

    <!--Stats-->
    <?php if($homePageSettings->enable_stats): ?>
        <?php if (isset($component)) { $__componentOriginal24526ccdbd5854c84782229da5700526 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal24526ccdbd5854c84782229da5700526 = $attributes; } ?>
<?php $component = App\View\Components\Stats::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('stats'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Stats::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal24526ccdbd5854c84782229da5700526)): ?>
<?php $attributes = $__attributesOriginal24526ccdbd5854c84782229da5700526; ?>
<?php unset($__attributesOriginal24526ccdbd5854c84782229da5700526); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal24526ccdbd5854c84782229da5700526)): ?>
<?php $component = $__componentOriginal24526ccdbd5854c84782229da5700526; ?>
<?php unset($__componentOriginal24526ccdbd5854c84782229da5700526); ?>
<?php endif; ?>
    <?php endif; ?>

    <!--Testimonials-->
    <?php if($homePageSettings->enable_testimonials): ?>
        <?php if (isset($component)) { $__componentOriginal8b46f742140ceac35ef472f1c16101e8 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal8b46f742140ceac35ef472f1c16101e8 = $attributes; } ?>
<?php $component = App\View\Components\Testimonials::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('testimonials'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Testimonials::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal8b46f742140ceac35ef472f1c16101e8)): ?>
<?php $attributes = $__attributesOriginal8b46f742140ceac35ef472f1c16101e8; ?>
<?php unset($__attributesOriginal8b46f742140ceac35ef472f1c16101e8); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal8b46f742140ceac35ef472f1c16101e8)): ?>
<?php $component = $__componentOriginal8b46f742140ceac35ef472f1c16101e8; ?>
<?php unset($__componentOriginal8b46f742140ceac35ef472f1c16101e8); ?>
<?php endif; ?>
    <?php endif; ?>

    <!--CTA-->
    <?php if($homePageSettings->enable_cta): ?>
        <?php if (isset($component)) { $__componentOriginala3c1d951ce64ffbbe4289a42ad7c6d3d = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginala3c1d951ce64ffbbe4289a42ad7c6d3d = $attributes; } ?>
<?php $component = App\View\Components\Cta::resolve([] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('cta'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\App\View\Components\Cta::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes([]); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginala3c1d951ce64ffbbe4289a42ad7c6d3d)): ?>
<?php $attributes = $__attributesOriginala3c1d951ce64ffbbe4289a42ad7c6d3d; ?>
<?php unset($__attributesOriginala3c1d951ce64ffbbe4289a42ad7c6d3d); ?>
<?php endif; ?>
<?php if (isset($__componentOriginala3c1d951ce64ffbbe4289a42ad7c6d3d)): ?>
<?php $component = $__componentOriginala3c1d951ce64ffbbe4289a42ad7c6d3d; ?>
<?php unset($__componentOriginala3c1d951ce64ffbbe4289a42ad7c6d3d); ?>
<?php endif; ?>
    <?php endif; ?>
<?php $__env->stopSection(); ?>

<?php echo $__env->make('store.layout', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH C:\Users\rakhi\Desktop\Trie\resources\views/store/index.blade.php ENDPATH**/ ?>