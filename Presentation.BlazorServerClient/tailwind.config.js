const colors = require("tailwindcss/colors");

module.exports = {
    content: [
        "./wwwroot/**/*.html",
        "./**/*.razor"
    ],
    theme: {
        extend: {},
    },
    plugins: [
        require('daisyui'),
    ],

}
