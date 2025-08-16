<!DOCTYPE html>
<html dir="{{ app(\App\Settings\LocalizationSettings::class)->default_direction }}" lang="{{ str_replace('_', '-', app()->getLocale()) }}">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <title>{{ config('app.name', 'QwikTest') }}</title>
        <meta name="description" content="{{ app(\App\Settings\SiteSettings::class)->seo_description }}">
        <link rel="icon" href="{{ url('storage/'.app(\App\Settings\SiteSettings::class)->favicon_path) }}">

        <!-- Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link rel="stylesheet" href="{{ config('qwiktest.default_font_url') }}">

        <!-- Styles -->
        <link rel="stylesheet" href="{{ asset('vendor/primeicons/primeicons.css') }}">
        <link rel="stylesheet" href="{{ asset('vendor/nprogress/nprogress.css') }}">
        <link rel="stylesheet" href="{{ asset('vendor/katex/katex.min.css') }}">
        @if(app()->environment('testing'))
            <link rel="stylesheet" href="{{ asset('css/app.css') }}">
        @else
            @vite('resources/css/app.css')
        @endif
        <style>
            :root {
                /* Custom Theme Configuration */
                --custom-font: "{{ config('qwiktest.default_font') }}";
                --primary-color: {{ '#'.app(\App\Settings\ThemeSettings::class)->primary_color }};
                --secondary-color: {{ '#'.app(\App\Settings\ThemeSettings::class)->secondary_color }};
            }
        </style>

        <!-- Scripts -->
        @routes
        <script src="{{ asset('vendor/katex/katex.min.js') }}"></script>
        <script src="{{ asset('vendor/katex/contrib/auto-render.min.js') }}"></script>
        
        @if(config('qwiktest.enable_mathjax', false))
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
        @endif
        
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
        @if(app()->environment('testing'))
            <script src="{{ asset('js/app.js') }}" defer></script>
        @else
            @vite('resources/js/app.js')
        @endif
    </head>
    <body class="font-sans antialiased bg-gray-100 dark:bg-gray-900">
        @inertia
        
        <!-- Modal teleport target -->
        <div id="modals"></div>
    </body>
</html>
