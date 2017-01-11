var AutoPrefixer = require('autoprefixer');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var HtmlPlugin = require('html-webpack-plugin');
var Path = require( 'path' );
var Webpack = require('webpack');
var WebpackMerge = require('webpack-merge');

var entryPath = Path.join(__dirname, 'src/app.js');
var outputPath = Path.join(__dirname, 'build');
var common_settings;
var environment_settings;
var environment;
var npm_target = process.env.npm_lifecycle_event;

if (npm_target === 'start') {
    environment = 'development';
} else if (npm_target === 'build') {
    environment = 'production';
}

common_settings = {
    entry: {
        app: entryPath
    },

    plugins: [
        new HtmlPlugin({
            template: Path.join(__dirname, 'src/index.html')
        }),
        new Webpack.optimize.OccurenceOrderPlugin()
    ],

    resolve: {
        extensions: ['', '.js', '.css', '.elm']
    },

    postcss: [
        AutoPrefixer({
            browsers: ['last 2 versions']
        })
    ],

}

if (environment === 'development') {
    environment_settings = {
        output: {
            path: outputPath,
            filename: '[name].js',
            publicPath: '/'
        },

        plugins: [
            new ExtractTextPlugin('app.css')
        ],

        module: {
            loaders: [{
                    test: /\.css$/,
                    loader: ExtractTextPlugin.extract('style', 'css!postcss')
                },
                {
                    test: /\.elm$/,
                    exclude: [
                        /elm-stuff/,
                        /node_modules/,
                    ],
                    loaders: [
                        'elm-hot-loader',
                        'elm-webpack-loader?verbose=true&warn=true&debug=false'
                    ]
                }
            ],
        },
    }
} else if (environment === 'production') {
    environment_settings = {
        output: {
            path: outputPath,
            filename: '[name]-[hash].min.js',
        },

        plugins: [
            new ExtractTextPlugin('app-[hash].min.css'),
            new Webpack.optimize.UglifyJsPlugin({
                mangle: true,
                minimize: true,
                sourceMap: false,
                comments: false,
                compress: {
                    warnings: false
                }
            })
        ],


        module: {
            loaders: [{
                    test: /\.css$/,
                    loader: ExtractTextPlugin.extract('style', 'css!postcss')
                },
                {
                    test: /\.elm$/,
                    exclude: [
                        /elm-stuff/,
                        /node_modules/,
                    ],
                    loaders: [
                        'elm-hot-loader',
                        'elm-webpack-loader?verbose=true&warn=true&debug=false'
                    ]
                }
            ],
        }
    }
}

module.exports = WebpackMerge(common_settings, environment_settings);
