process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

environment.loaders.prepend('sass', {
    test: /\.(css|scss|sass)$/,
    use: [{
        loader: 'style-loader'
    }, {
        loader: 'css-loader'
    }, {
        loader: 'sass-loader',
        options: {
            includePaths: ['node_modules'],
        }
    }]
})

module.exports = environment.toWebpackConfig()
