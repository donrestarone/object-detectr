const { environment } = require('@rails/webpacker')
// bootstrap jquery setup
const webpack = require("webpack")
environment.plugins.append("Provide", new webpack.ProvidePlugin({
$: 'jquery',
jQuery: 'jquery',
Popper: ['popper.js', 'default']
}))

const config = environment.toWebpackConfig();

config.resolve.alias = {
  jquery: 'jquery/src/jquery'
 };
// bootstrap jquery setup

module.exports = environment