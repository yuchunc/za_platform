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
          use: ExtractTextPlugin.extract({
            fallback: "sass-loader",
            use: ['css-loader', 'postcss-loader', 'sass-loader']
          })
        },
        {
          test: /\.(png|woff|woff2|eot|ttf|svg)$/,
          loader: 'url-loader',
          options: {
            limit: 8192
          }
        }
      ]
    },

    plugins: [
      new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery'
      }),

      new CopyWebpackPlugin([{
        from: "./static",
        to: path.resolve(__dirname, "../priv/static")
      }]),

      new ExtractTextPlugin({
        filename: "css/[name].css",
        allChunks: true
      })
    ],

    optimization: {
      splitChunks: {
        cacheGroups: {
          theme: {
            test: /[\\/]vendor[\\/]/,
            name: "theme",
            chunks: "all"
          }
        }
      }
    }
  }
};

module.exports = config_fn;
