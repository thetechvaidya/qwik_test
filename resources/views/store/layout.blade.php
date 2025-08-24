<!DOCTYPE html>
<html dir="{{ app(\App\Settings\LocalizationSettings::class)->default_direction }}" lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>@yield('title') - {{ config('app.name', 'QwikTest') }}</title>
    <meta name="description" content="{{ app(\App\Settings\SiteSettings::class)->seo_description }}">
    @php
        $faviconPath = app(\App\Settings\SiteSettings::class)->favicon_path;
    @endphp
    @if($faviconPath)
        <link rel="icon" href="{{ url('storage/'.$faviconPath) }}">
    @endif

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="{{ config('qwiktest.default_font_url') }}">

    <!-- Styles -->
    @if(app()->environment('testing'))
        <link rel="stylesheet" href="{{ asset('css/store.css') }}">
    @else
        @vite('resources/css/store.css')
    @endif
    <style>
        :root {
            /* Custom Theme Configuration */
            --custom-font: "{{ config('qwiktest.default_font') }}";
            --primary-color: {{ '#'.app(\App\Settings\ThemeSettings::class)->primary_color }};
            --secondary-color: {{ '#'.app(\App\Settings\ThemeSettings::class)->secondary_color }};
        }
    </style>
    @stack('styles')
    <!-- Scripts -->
    <script src="{{ asset('vendor/alpinejs/alpine.min.js') }}" defer></script>
</head>
<body class="font-sans antialiased bg-white dark:bg-black">
    <!--TopBar-->
    <x-top-bar/>
    <!--NavBar-->
    <x-navbar/>
    @yield('content')
    <!--Footer-->
    <x-footer/>
@stack('scripts')
</body>
</html>
