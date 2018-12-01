const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const autoprefixer = require('autoprefixer');
const webpack = require('webpack');

module.exports = {
  context: __dirname,

  entry: {
    app: [
      "./js/app.js",
      "./stylesheets/app.scss"
    ]
  },

  output: {
    path: path.resolve(__dirname, "../priv/static"),
    filename: 'js/[name].js',
    publicPath: 'http://localhost:4000/'
  },

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        query: {
          presets: ['@babel/preset-env'],
        },
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
        test: /\.(svg|jpg|png|gif)$/,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]?[hash]',
            }
          }
        ]
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
    }])
  ]
};

