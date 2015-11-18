# Description
#   Run commands using blazemeter with hubot
#
# Configuration:
#
# Commands:
#
#   hubot bm whoami
#   hubot bm get api key
#   hubot bm get env
#   hubot bm set api key <apiKey>
#   hubot bm set env <env>
#   hubot bm list (tests|collections|masters|sessions)
#   hubot bm list running (tests|collections|masters|sessions)
#   hubot bm run test <test_id>
#
# Notes:
#   Uses the following packages
#
#   - https://www.npmjs.com/package/request
#
# Author:
#   Gilad Peleg
request = require 'request'

collections = ['tests', 'collections', 'masters', 'sessions']

getRequestOptions = (apiKey, env, route, method = "GET") ->
  return {
    url: "#{env}/api/latest/#{route}"
    method: method
    headers: {
      'x-api-key': apiKey
    },
    json: true
  }

isUserValid = (user) ->
  unless user.bmEnv
    return res.reply "You have not set your blazemeter env"
  unless user.bmApiKey
    return res.reply "You have not set your blazemeter api-key"
  return true

handleError = (err, response, robotResponse) ->
  if err
    return robotResponse.reply "Something went terribly wrong"

  if response.statusCode > 400
    return robotResponse.reply "Got #{response.statusCode}: #{response.statusMessage}"

  robotResponse.reply "I don't know what to do. Tried to take over the world"

runRequest = (user, route, method, cb) ->
  options = getRequestOptions user.bmApiKey, user.bmEnv, route
  request.get options, cb

module.exports = (robot) ->
  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"
    if res?
      res.reply "DOES NOT COMPUTE"

  robot.respond /bm whoami/i, (res) ->
    user = robot.brain.userForId res.message.user.id
    return unless user

    validation = isUserValid user
    unless validation is true
      return res.reply validation

    route = "user"
    method = "GET"

    runRequest user, route, method, (err, response, body) ->
      return handleError(err, response, res) if err or response.statusCode >= 400

      display = body.result.displayName
      res.reply "Successfully checked in with #{user.bmEnv}. Using #{display}."

  robot.respond /bm set env ([^\s]+)/i, (res) ->
    user = robot.brain.userForId res.message.user.id
    return unless user

    value = res.match[1]
    user.bmEnv = value
    robot.brain.save()
    res.reply "Got it, I updated your env to be #{value}"

  robot.respond /bm get env/i, (res) ->
    user = robot.brain.userForId res.message.user.id
    return unless user

    value = user.bmEnv
    unless value
      return res.reply "Your env is unset"

    res.reply "You env is set to be #{value}"

  robot.respond /bm set api key (\w+)/i, (res) ->
    user = robot.brain.userForId res.message.user.id
    return unless user

    value = res.match[1]
    user.bmApiKey = value
    robot.brain.save()
    res.reply "Got it, I updated your api key to be #{value}"

  robot.respond /bm get env/i, (res) ->
    user = robot.brain.userForId res.message.user.id
    return unless user

    value = user.bmApiKey
    unless value
      return res.reply "Your api key is unset"

    res.reply "You api key is set to be #{value}"

  robot.respond /bm list (\w+)$/i, (res) ->
    collection = res.match[1]
    unless collection in collections
      return res.reply "I'm not programmed to list #{collection}"

    user = robot.brain.userForId res.message.user.id
    return unless user

    validation = isUserValid user
    unless validation is true
      return res.reply validation

    route = "#{collection}?limit=10"
    method = "GET"

    runRequest user, route, method, (err, response, body) ->
      return handleError(err, response, res) if err or response.statusCode >= 400
      items = body.result
      idList = ("#{item.id} - #{item.name}" for item in items)
      res.reply idList.join '\n'

  robot.respond /bm stop test (\w+)$/i, (res) ->
    test = res.match[1]

    user = robot.brain.userForId res.message.user.id
    return unless user

    validation = isUserValid user
    unless validation is true
      return res.reply validation

    route = "tests/#{test}/stop"
    method = "POST"
    res.reply "Stopping test #{test}. This might take a while..."

    runRequest user, route, method, (err, response, body) ->
      return handleError(err, response, res) if err or response.statusCode >= 400

      res.reply "Successfully sent the stop command"

  robot.respond /bm run test (\w+)$/i, (res) ->
    test = res.match[1]

    user = robot.brain.userForId res.message.user.id
    return unless user

    validation = isUserValid user
    unless validation is true
      return res.reply validation

    route = "tests/#{test}/start"
    method = "POST"
    res.reply "Launching test #{test}. This might take a while..."

    runRequest user, route, method, (err, response, body) ->
      return handleError(err, response, res) if err or response.statusCode >= 400

      res.reply "Successfully launched the test with master #{body.result.id}"

  robot.respond /bm list running (\w+)$/i, (res) ->
    collection = res.match[1]
    unless collection in collections
      return res.reply "I'm not programmed to list #{collection}"

    user = robot.brain.userForId res.message.user.id
    return unless user

    validation = isUserValid user
    unless validation is true
      return res.reply validation

    route = "web/active"
    method = "GET"

    runRequest user, route, method, (err, response, body) ->
      return handleError(err, response, res) if err or response.statusCode >= 400

      items = body?.result?[collection]
      if items?.length > 0
        res.reply "Current running #{collection}: #{items}"
      else
        res.reply "There are no running #{collection}"
