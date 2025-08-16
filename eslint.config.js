import pluginVue from 'eslint-plugin-vue'
import eslintConfigPrettier from '@vue/eslint-config-prettier'

export default [
  {
    name: 'app/files-to-lint',
    files: ['**/*.{js,mjs,cjs,vue}'],
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: {
        defineProps: 'readonly',
        defineEmits: 'readonly',
        defineExpose: 'readonly',
        withDefaults: 'readonly',
        route: 'readonly',
        __: 'readonly'
      }
    },
    linterOptions: {
      reportUnusedDisableDirectives: true
    },
    rules: {
      // JavaScript rules
      'no-console': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
      'no-debugger': process.env.NODE_ENV === 'production' ? 'warn' : 'off',
      'no-unused-vars': 'warn',
      'no-undef': 'error'
    }
  },

  {
    name: 'app/vue-files',
    files: ['**/*.vue'],
    languageOptions: {
      parser: pluginVue.parseForESLint,
      parserOptions: {
        ecmaVersion: 2022,
        sourceType: 'module'
      }
    },
    plugins: {
      vue: pluginVue
    },
    processor: pluginVue.processors['.vue'],
    rules: {
      // Vue template validation rules
      'vue/no-parsing-error': 'error',
      'vue/html-end-tags': 'error',
      'vue/html-self-closing': 'error',
      'vue/no-template-shadow': 'error',
      'vue/valid-template-root': 'error',
      'vue/valid-v-for': 'error',
      'vue/require-v-for-key': 'error',
      'vue/no-use-v-if-with-v-for': 'error',
      'vue/html-closing-bracket-newline': ['error', {
        'singleline': 'never',
        'multiline': 'always'
      }],
      'vue/html-closing-bracket-spacing': 'error',
      'vue/max-attributes-per-line': ['error', {
        'singleline': 3,
        'multiline': 1
      }],
      'vue/multiline-html-element-content-newline': 'error',
      'vue/no-multi-spaces': 'error',
      'vue/no-spaces-around-equal-signs-in-attribute': 'error',
      'vue/require-default-prop': 'error',
      'vue/require-prop-types': 'error',
      'vue/v-bind-style': 'error',
      'vue/v-on-style': 'error',
      'vue/attributes-order': 'error',
      'vue/order-in-components': 'error',
      'vue/this-in-template': 'error'
    }
  },

  // Vue 3 recommended configurations
  ...pluginVue.configs['flat/essential'],
  ...pluginVue.configs['flat/strongly-recommended'],
  ...pluginVue.configs['flat/recommended'],
  
  // Prettier configuration
  eslintConfigPrettier,

  {
    name: 'app/ignored-files',
    ignores: [
      'public/**/*',
      'vendor/**/*',
      'storage/**/*',
      'bootstrap/cache/**/*',
      'node_modules/**/*',
      'dist/**/*',
      'build/**/*'
    ]
  }
]