const path = require('path');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const autoprefixer = require('autoprefixer');
const webpack = require('webpack');

const config_fn = (env) => {
  const isDev = !(env && env.prod);
  const devtool = isDev ? "eveal" : "source-map";

  return {
    mode: "development",

    devtool: devtool,

    context: __dirname,

    entry: {
      app: [
        "./js/app.js",
        "./scss/app.scss"
      ]
    },

    output: {
      path: path.resolve(__dirname, "../priv/static"),
      filename: 'js/[name].js',
      publicPath: 'http://localhost:8080/'
    },

    devServer: {
      headers: {
        "Access-control-Allow-Origin": "*"
      }
    },

    module: {
      rules: [
        {
          test: /\.(css|scss)$/,
          exclude: /node_modules/,
          use: isDev ? [
            "style-loader",
            "css-loader",
            "sass-loader"
          ] : ExtractTextPlugin.extract({
            fallback: "sass-loader",
            use: ['css-loader', 'sass-loader']
          })
        }
      ]
    },
    plugins: isDev ? [
      new CopyWebpackPlugin([{
        from: "./static",
        to: path.resolve(__dirname, "../priv/static")
      }])
    ] : [
      new CopyWebpackPlugin([{
        from: "./static",
        to: path.resolve(__dirname, "../priv/static")
      }]),

      new ExtractTextPlugin({
        filename: "css/[name].css",
        allChunks: true
      }),

      new webpack.optimize.UglifyJsPlugin({
        sourceMap: true,
        beautify: false,
        comments: false,
        extractComments: false,
        compress: {
          warnings: false,
          drop_console: true
        },
        mangle: {
          except: ['$'],
          screw_ie8: true,
          keep_fname: true
        }

      })
    ]
  }
};

module.exports = config_fn;
