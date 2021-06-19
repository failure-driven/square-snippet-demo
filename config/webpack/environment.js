const { environment } = require('@rails/webpacker')
const svelte = require('./loaders/svelte')

environment.loaders.prepend('svelte', svelte)

const webpack = require("webpack")

environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery",
    jQuery: "jquery",
    jquery: "jquery",
    "window.jQuery": "jquery",
    Popper: ["popper.js", "default"],
  })
);
module.exports = environment
