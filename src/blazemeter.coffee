# Description
#   Run commands using blazemeter with hubot
#
# Configuration:
#
# Commands:
#
#   hubot bm whoami
#
#   hubot bm get api key
#   hubot bm set api key <apiKey>
#
#   hubot bm get env
#   hubot bm set env <env>
#
#   hubot bm list (tests|collections|masters|sessions)
#   hubot bm list running (tests|collections|masters|sessions)
#
#   hubot bm run test <test_id>
#   hubot bm stop test <test_id>
#
# Notes:
#   Uses the following packages
#
#   - https://www.npmjs.com/package/request
#
# Author:
#   Gilad Peleg

handlers = require './lib/handlers'

module.exports = (robot) ->
  handlers.setRobot robot

  robot.error (err, res) ->
    robot.logger.error "DOES NOT COMPUTE"
    if res?
      res.reply "DOES NOT COMPUTE"

  robot.respond /bm get api key/i, handlers.handleGetApiKey
  robot.respond /bm get env$/i, handlers.handleGetEnv
  robot.respond /bm list (\w+)$/i, handlers.handleListCollections
  robot.respond /bm list running (\w+)$/i, handlers.handleListRunning
  robot.respond /bm run test (\w+)$/i, handlers.handleRunTest
  robot.respond /bm set api key (\w+)$/i, handlers.handleSetApiKey
  robot.respond /bm set env ([^\s]+)$/i, handlers.handleSetEnv
  robot.respond /bm stop test (\w+)$/i, handlers.handleStopTest
  robot.respond /bm whoami$/i, handlers.handleWhoami
