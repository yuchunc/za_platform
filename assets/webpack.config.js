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
      publicPath: 'http://localhost:4000/'
    },

    devServer: {
      headers: {
        "Access-control-Allow-Origin": "*"
      }
    },

    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          loader: 'babel',
          query: {
            presets: ['es2015'],
          },
        },
        {
          test: /\.(css|scss)$/,
          use: ExtractTextPlugin.extract({
            fallback: "sass-loader",
            use: ['css-loader', 'postcss-loader', 'sass-loader']
          })
        },
        {
          test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          loader: "file-loader",
          query: {
            name: "fonts/[hash].[ext]",
            mimetype: "application/font-woff"
          }
        },
        {
          test: /\.(eot|svg|ttf)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
          loader: "file-loader",
          query: {
            name: "fonts/[hash].[ext]"
          }
        },
        {
          test: /\.png$/,
          loader: 'file-loader',
          options: {
            name: 'images/[name].[ext]'
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
    ]
  }
};

module.exports = config_fn;
