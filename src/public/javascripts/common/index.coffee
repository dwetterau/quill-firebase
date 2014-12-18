utils = require('./utils')

module.exports = Object.freeze
  config: require('./config')
  constants: utils.deep_freeze require('./constants')
  utils: utils