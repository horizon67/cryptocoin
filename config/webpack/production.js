const environment = require('./environment')

//module.exports = environment.toWebpackConfig()

module.exports = Object.assign({}, environment.toWebpackConfig(), {
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js'
    }
  }
})
