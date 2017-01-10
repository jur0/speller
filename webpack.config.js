var Webpack = require('webpack');

var AutoPrefixer = require('autoprefixer');
var CleanPlugin = require('clean-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var HtmlPlugin = require('html-webpack-plugin');

var build_dir = 'build'

module.exports = {
    entry: {
        app: './src/app.js',
    },

    output: {
        path: build_dir,
        filename: 'app.js',
    },

    plugins: [
        new CleanPlugin(build_dir),

        new ExtractTextPlugin('app.css'),

        new HtmlPlugin({
            template: './src/index.html',
        }),
    ],

    postcss: [
        AutoPrefixer({
            browsers: ['last 2 versions']
        })
    ],

    resolve: {
        modulesDirectories: ['node_modules'],
        extensions: ['', '.css', '.elm']
    },


    module: {
        loaders: [{
                test: /\.css/,
                loader: ExtractTextPlugin.extract('style', 'css'),
            },

            {
                test: /\.elm$/,
                exclude: [
                    /elm-stuff/,
                    /node_modules/,
                ],
                loader: 'elm-webpack-loader?verbose=true&warn=true&debug=false'
            }
        ],
    },
}
