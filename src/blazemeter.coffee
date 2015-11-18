# Description
#   Run commands using blazemeter with hubot
#
# Configuration:
#   HUBOT_BM_API_KEY="HKDJFKJFKDJFDF"
#   HUBOT_BM_DOMAIN="http://a.blazemeter.com"
#
# Commands:
#
#   hubot bm (run|stop|terminate) test <test_id>
#   hubot bm list (tests|collections|masters|sessions)
#   hubot bm list running (tests|collections|masters|sessions)
#   hubot bm who is the best <job>
#   hubot bm whoami
#
# Notes:
#   Uses the following packages
#
#   - https://www.npmjs.com/package/request
#
# Author:
#   Gilad Peleg
request = require 'request'

people = ['Alon', 'Yuli', 'Hai', 'Vitali', 'Gilad', 'Alex', 'Dor', 'Jason', 'Yaniv', 'Guy']
collections = ['tests', 'collections', 'masters', 'sessions']

module.exports = (robot) ->
  apiKey = process.env.HUBOT_BM_API_KEY
  domain = process.env.HUBOT_BM_DOMAIN or 'http://a.blazemeter.com'

  throw Error "Missing api key. Please define HUBOT_BM_API_KEY" unless apiKey
  urlPrefix = "#{domain}/api/latest"

  instance = request.defaults {
    headers: {
      'x-api-key': apiKey
    },
    json: true
  }

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"

    if res?
      res.reply "DOES NOT COMPUTE"

  robot.respond /bm do i have an api key/i, (res) ->
    res.reply "yeah you do!"

  robot.respond /bm who is the best (.+)/i, (res) ->
    job = res.match[1]
    person = res.random people
    res.reply "#{person} is the best #{job}"

  robot.respond /bm whoami/i, (res) ->
    url = "#{urlPrefix}/user"
    instance.get url, (error, response, body) ->
      res.reply body.result.displayName

  robot.respond /bm run test (\w+)/i, (res) ->
    test = res.match[1]
    res.reply "Once I'm configured I will run your test #{test}"

  robot.respond /bm list (\w+)/i, (res) ->
    collection = res.match[1]
    unless collection in collections
      return res.reply "I'm not programmed to list #{collection}"

    url = "#{urlPrefix}/#{collection}"
    instance.get url, (error, response, body) ->
      items = body.result
      idList = (item.id for item in items)
      res.reply idList.join ', '

  robot.respond /bm list running (\w+)/i, (res) ->
    collection = res.match[1]
    unless collection in collections
      return res.reply "I'm not programmed to list running #{collection}"

    url = "#{urlPrefix}/web/active"
    instance.get url, (error, response, body) ->
      items = body?.result?[collection]
      if items?.length > 0
        res.reply "Current running #{collection}: #{items}"
      else
        res.reply "There are no running #{collection}"
