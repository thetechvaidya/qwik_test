export default {
  plugins: {
    'postcss-import': {
      path: ['resources/css'],
      skipDuplicates: true,
    },
    'tailwindcss': {
      config: './tailwind.config.js',
    },
    'autoprefixer': {
      grid: 'autoplace',
      flexbox: 'no-2009',
      overrideBrowserslist: [
        '> 1%',
        'last 2 versions',
        'not dead',
        'not ie <= 11'
      ],
    },
  },
  map: (typeof process !== 'undefined' && process.env.NODE_ENV === 'development') ? { inline: false } : false,
}