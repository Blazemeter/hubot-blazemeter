# hubot-blazemeter

> A [Hubot](https://hubot.github.com/) script for BlazeMeter integration

Hubot allows you to run [BlazeMeter](https://blazemeter.com/) commands using Hubot,
which integrates with any leading chat clients (Knowingly HipChat, Slack, IRC, etc..)

### Preparation

Required:

- You will need to have a BlazeMeter account, or access to one. [Signup for one now!](https://blazemeter.com/#signup)
- You will need to have a BlazeMeter Api Key
- A workable environment (usually `https://a.blazemeter.com` but configurable to any other env)

### Installation

- Install this npm package to your hubot repo:

```bash
$ npm install --save blazemeter-hubot
```

- Add `blazemeter-hubot` to your `external-scripts.json`

`hubot-blazemeter` requires a connection to redis to persist data.
See [Hubot Redis Brain](https://github.com/hubot-scripts/hubot-redis-brain) for details.

(This usually means you will need to set `REDIS_URL` env variable)

### Usage

In order to start using BlazeMeter's API, you will need to setup 2 variables with Hubot:
- Env endpoint (Usually `http://a.blazemeter.com`).
- API Key (You can find this at: http://a.blazemeter.com/app/#settings/api-key)

Example workflow:

```
hubot bm set env http://a.blazemeter.com
hubot bm set api key ZdjX888gggjmJghA8vnU
```

These are a list of `hubot-blazemeter` commands:

#### Setup

- `hubot bm whoami`

- `hubot bm get api key`
- `hubot bm set api key <apiKey>`

- `hubot bm get env`
- `hubot bm set env <env>`

#### Listing

- `hubot bm list (tests|collections|masters|sessions)`
- `hubot bm list running (tests|collections|masters|sessions)`

#### Using

- `hubot bm (run|stop|terminate) test <test_id>`

### Get Involved

1. fork it (https://github.com/Blazemeter/hubot-blazemeter/fork)
2. create your feature branch (`git checkout -b my-new-feature`)
3. commit your changes (`git commit -am 'Add some feature'`)
4. push to the branch (`git push origin my-new-feature`)
5. Create new pull request
