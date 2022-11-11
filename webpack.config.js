const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const HtmlWebpackPlugin = require("html-webpack-plugin");
const path = require('path');

module.exports = {
    entry: "./src/index",
    mode: "development",
    devtool: 'source-map',
    plugins: [
        new MiniCssExtractPlugin(),
        new HtmlWebpackPlugin({
            template: "src/index.html"
        })
    ],
    module: {
        rules: [
            { 
                test: /\.(ts|js)x?$/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-typescript']
                    }
                },
                exclude: /node_modules/,
                
            },
            {
                test: /\.css$/i,
                use: [MiniCssExtractPlugin.loader, 'css-loader']
            },
            {
                test: /\.s[ac]ss$/i,
                use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader']
            },
            {
                test: /\.(png|jpe?g|gif)$/,
                type: 'asset/resource',
            }
        ],
    },
    resolve: { extensions: ['.tsx', '.ts', '.js'] },
    output: { 
        path: path.resolve(__dirname, 'dist'),
        filename: 'game.js',
        publicPath: ''
    },
    performance: {
        hints: false
    },
    devServer: {
        compress: true,
        port: 3000,
    },
}