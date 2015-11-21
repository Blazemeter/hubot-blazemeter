Helper = require('hubot-test-helper')
expect = require('expect.js')
helper = new Helper('../src/blazemeter.coffee')
hat = require 'hat'

describe 'api-key', ->

  beforeEach ->
    @room = helper.createRoom()
    # generate random api key
    @apiKey = hat()

  afterEach ->
    @room.destroy()

  it 'should be unset at start', (done) ->

    @room.user.say 'alice', '@hubot bm get api key'
    .then =>
      expect(@room.messages).to.have.length(2)
      expect(@room.messages[0]).to.eql [
        'alice', '@hubot bm get api key'
      ]
      expect(@room.messages[1]).to.eql [
        'hubot', '@alice Your api key is unset'
      ]
      done()
    .catch done

  it 'should be able to be set by user', (done) ->
    @room.user.say 'alice', "@hubot bm set api key #{@apiKey}"
    .then =>
      expect(@room.messages).to.have.length(2)
      response = "@alice Got it, I updated your api key to be #{@apiKey}"
      expect(@room.messages[1]).to.eql [
        "hubot", response
      ]
      done()
    .catch done

  it 'should return the correct api key after being set', (done) ->
    @room.user.say 'alice', "@hubot bm set api key #{@apiKey}"
    .then =>
      @room.user.say 'alice', '@hubot bm get api key'
    .then =>
      expect(@room.messages).to.have.length(4)
      expect(@room.messages[3]).to.eql [
        'hubot', "@alice Your api key is set to be #{@apiKey}"
      ]
      done()
    .catch done

  it 'should reset api key', (done) ->
    @room.user.say 'alice', "@hubot bm set api key #{@apiKey}"
    .then =>
      @room.user.say 'alice', '@hubot bm get api key'
    .then =>
      @room.user.say 'alice', '@hubot bm reset'
    .then =>
      expect(@room.messages).to.have.length(6)
      expect(@room.messages[5]).to.eql [
        'hubot', '@alice Your env and api key are reset'
      ]
    .then =>
      @room.user.say 'alice', '@hubot bm get api key'
    .then =>
      expect(@room.messages).to.have.length(8)
      expect(@room.messages[7]).to.eql [
        'hubot', '@alice Your api key is unset'
      ]
      done()
    .catch done
