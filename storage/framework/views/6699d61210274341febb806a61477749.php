<!DOCTYPE html>
<html dir="<?php echo e(app(\App\Settings\LocalizationSettings::class)->default_direction); ?>" lang="<?php echo e(str_replace('_', '-', app()->getLocale())); ?>">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="<?php echo e(csrf_token()); ?>">

        <title><?php echo e(config('app.name', 'QwikTest')); ?></title>
        <meta name="description" content="<?php echo e(app(\App\Settings\SiteSettings::class)->seo_description); ?>">
        <?php
            $faviconPath = app(\App\Settings\SiteSettings::class)->favicon_path;
        ?>
        <?php if($faviconPath): ?>
            <link rel="icon" href="<?php echo e(url('storage/'.$faviconPath)); ?>">
        <?php endif; ?>

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="<?php echo e(config('qwiktest.default_font_url')); ?>">

        <!-- Styles -->
        <link rel="stylesheet" href="<?php echo e(asset('vendor/primeicons/primeicons.css')); ?>">
        <link rel="stylesheet" href="<?php echo e(asset('vendor/nprogress/nprogress.css')); ?>">
        <link rel="stylesheet" href="<?php echo e(asset('vendor/katex/katex.min.css')); ?>">
        <?php if(app()->environment('testing')): ?>
            <link rel="stylesheet" href="<?php echo e(asset('css/app.css')); ?>">
        <?php else: ?>
            <?php echo app('Illuminate\Foundation\Vite')('resources/css/app.css'); ?>
        <?php endif; ?>
        <style>
            :root {
                /* Custom Theme Configuration */
                --custom-font: "<?php echo e(config('qwiktest.default_font')); ?>";
                --primary-color: <?php echo e('#'.app(\App\Settings\ThemeSettings::class)->primary_color); ?>;
                --secondary-color: <?php echo e('#'.app(\App\Settings\ThemeSettings::class)->secondary_color); ?>;
            }
        </style>

        <!-- Scripts -->
        <?php echo app('Tighten\Ziggy\BladeRouteGenerator')->generate(); ?>
        <script src="<?php echo e(asset('vendor/katex/katex.min.js')); ?>"></script>
        <script src="<?php echo e(asset('vendor/katex/contrib/auto-render.min.js')); ?>"></script>
        
        <?php if(config('qwiktest.enable_mathjax', false)): ?>
        <!-- Optional MathJax v3 loader for advanced mathematical content -->
        <script>
        window.MathJax = {
            tex: {
                inlineMath: [['$', '$'], ['\\(', '\\)']],
                displayMath: [['$$', '$$'], ['\\[', '\\]']],
                processEscapes: true,
                processEnvironments: true
            },
            options: {
                ignoreHtmlClass: 'ProseMirror|tiptap-content|tiptap-editor',
                processHtmlClass: 'mathjax-process'
            },
            startup: {
                ready: () => {
                    console.log('MathJax v3 loaded as secondary renderer');
                    MathJax.startup.defaultReady();
                }
            }
        };
        </script>
        <script type="text/javascript" id="MathJax-script" async
            src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js">
        </script>
        <?php endif; ?>
        
        <script>
            // KaTeX auto-rendering utility function
            function renderMathElements(container = document.body, forceInsideEditor = false) {
                if (typeof renderMathInElement !== 'undefined') {
                    const options = {
                        delimiters: [
                            {left: '$$', right: '$$', display: true},
                            {left: '$', right: '$', display: false},
                            {left: '\\[', right: '\\]', display: true},
                            {left: '\\(', right: '\\)', display: false}
                        ],
                        throwOnError: false,
                        strict: false,
                        // Exclude Tiptap editor content from auto-rendering
                        ignoredTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
                    };
                    
                    // Only add ignoredClasses if not forcing inside editor
                    if (!forceInsideEditor) {
                        options.ignoredClasses = ['ProseMirror', 'tiptap-content', 'tiptap-editor'];
                    }
                    
                    renderMathInElement(container, options);
                }
            }

            // Initialize KaTeX auto-rendering when DOM is ready, excluding editor content
            document.addEventListener('DOMContentLoaded', function() {
                renderMathElements();
            });

            // Re-render math after Inertia navigation for SPA support
            document.addEventListener('inertia:success', function() {
                // Use setTimeout to ensure DOM has updated
                setTimeout(() => {
                    renderMathElements();
                }, 10);
            });
        </script>
        <?php if(app()->environment('testing')): ?>
            <script src="<?php echo e(asset('js/app.js')); ?>" defer></script>
        <?php else: ?>
            <?php echo app('Illuminate\Foundation\Vite')('resources/js/app.js'); ?>
        <?php endif; ?>
    </head>
    <body class="font-sans antialiased bg-gray-100 dark:bg-gray-900">
        <?php if (!isset($__inertiaSsrDispatched)) { $__inertiaSsrDispatched = true; $__inertiaSsrResponse = app(\Inertia\Ssr\Gateway::class)->dispatch($page); }  if ($__inertiaSsrResponse) { echo $__inertiaSsrResponse->body; } else { ?><div id="app" data-page="<?php echo e(json_encode($page)); ?>"></div><?php } ?>
        
        <!-- Modal teleport target -->
        <div id="modals"></div>
    </body>
</html>
<?php /**PATH C:\Users\goela\Desktop\Trie\resources\views/app.blade.php ENDPATH**/ ?>