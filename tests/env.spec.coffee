Helper = require('hubot-test-helper')
expect = require('expect.js')
helper = new Helper('../src/blazemeter.coffee')

describe 'env', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'should get unset env', (done) ->
    @room.user.say 'alice', '@hubot bm get env'
    .then =>
      expect(@room.messages).to.have.length(2)
      expect(@room.messages[0]).to.eql [
        'alice', '@hubot bm get env'
      ]
      expect(@room.messages[1]).to.eql [
        'hubot', '@alice Your env is unset'
      ]
      done()
    .catch done

  it 'should set env', (done) ->
    @room.user.say 'alice', '@hubot bm set env https://a.blazemeter.com'
    .then =>
      expect(@room.messages).to.have.length(2)
      response = "@alice Got it, I updated your env to be https://a.blazemeter.com"
      expect(@room.messages[1]).to.eql [
        "hubot", response
      ]
      done()
    .catch done

  it 'should get correct env', (done) ->
    @room.user.say 'alice', '@hubot bm set env https://a.blazemeter.com'
    .then =>
      @room.user.say 'alice', '@hubot bm get env'
    .then =>
      expect(@room.messages).to.have.length(4)
      expect(@room.messages[3]).to.eql [
        'hubot', '@alice Your env is set to be https://a.blazemeter.com'
      ]
      done()
    .catch done

  it 'should reset env', (done) ->
    @room.user.say 'alice', '@hubot bm set env https://a.blazemeter.com'
    .then =>
      @room.user.say 'alice', '@hubot bm get env'
    .then =>
      @room.user.say 'alice', '@hubot bm reset'
    .then =>
      expect(@room.messages).to.have.length(6)
      expect(@room.messages[5]).to.eql [
        'hubot', '@alice Your env and api key are reset'
      ]
    .then =>
      @room.user.say 'alice', '@hubot bm get env'
    .then =>
      expect(@room.messages).to.have.length(8)
      expect(@room.messages[7]).to.eql [
        'hubot', '@alice Your env is unset'
      ]
      done()
    .catch done
