{config, constants} = require '../common'
Firebase = require 'firebase'

exports.ROOT_REF = new Firebase('//' + config.firebase + '.firebaseio.com')
exports.OPERATION_REF = exports.ROOT_REF.child(constants.OPERATION_QUEUE)