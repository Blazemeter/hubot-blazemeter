#    hubot-blazemeter
A hubot script for blazemeter integration

Hubot allows you to run BlazeMeter commands from HipChat, or any other other messaging & collaboration service that has an integration.


### Preparation

Required: 

- You need to have a GitHub API key
- You need to have a BlazeMeter account (https://blazemeter.com/#signup)
- The environent will a.blazemeter.com
- you can optionally set up a different environment is you are using something else 


### Installation

- Install this npm package to your hubot repo
- - npm i --save blazemeter-hubot
- Add "blazemeter-hubot" to your external-scripts.json

Set the following env vars on Heroku

- HUBOT_BM_API_KEY
- HUBOT_BZ_DOMAIN	
- HUBOT_HIPCHAT_JID
- HUBOT_HIPCHAT_PASSWORD
- HUBOT_HIPCHAT_ROOMS
- REDIS_URL

### Usage

#  hubot bm (run|stop|terminate) test <test_id>
#  hubot bm list (tests|collections|masters|sessions)
#  hubot bm list running (tests|collections|masters|sessions)
#  hubot bm whoami


### Get Involved
1. fork it ( https://github.com/Blazemeter/hubot-blazemeter/fork )
2. create your feature branch (git checkout -b my-new-feature)
3. commit your changes (git commit -am 'Add some feature')
4. push to the branch (git push origin my-new-feature)
5. Create new pull request
