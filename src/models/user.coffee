bcrypt = require 'bcrypt'

module.exports = (sequelize, DataTypes) ->
  User = sequelize.define "User",
    username: {
      type: DataTypes.STRING
      unique: true
    }
    password: DataTypes.STRING
  , instanceMethods:

    hash_and_set_password: (unhashed_password, next) ->
      bcrypt.genSalt 5, (err, salt) =>
        if err?
          return next(err)
        bcrypt.hash unhashed_password, salt, (err, hash) =>
          if err?
            return next(err)
          @.setDataValue("password", hash)
          next()

    compare_password: (candidatePassword, next) ->
      bcrypt.compare candidatePassword, this.password, (err, is_match) ->
        if err?
          return next(err)
        next(null, is_match)

  return User
