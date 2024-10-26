import { defineConfig } from 'vite'

export default defineConfig({
    plugins: [],
    define: {
        __VUE_OPTIONS_API__: false,
        __VUE_PROD_DEVTOOLS__: true,
        __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: false,
    }
})
