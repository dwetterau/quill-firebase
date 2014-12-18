# Utility functions
exports.deep_freeze = (obj) ->
  for k, v of obj
    if typeof v == 'object'
      @.deep_freeze v
  Object.freeze obj

exports.random_color = () ->
  value = Math.random() * (255 * 255 * 255)
  return '#' + Math.floor(value).toString(16)
