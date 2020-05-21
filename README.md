# GreetingBot
Create SlackBot using AWS API Gateway and Lambda

Read this [blog](https://tech.unifa-e.com/entry/2020/05/21/105239) for more datail.

## Built With

* [Slack Event API](https://api.slack.com/events-api) - For handling the bot event.
* [AWS Lambda](https://aws.amazon.com/lambda/) - Ruby function to interact with SlackBot.
* [AWS API Gateway](https://aws.amazon.com/api-gateway/) - API end-point for the lambda function to receive the request from SlackBot.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to upload the function on AWS lambda.

### Prerequisites

What things you need to setup before running the application.

* Ruby version

  - Ruby-2.7

* Make sure you have AWS Account and you have configured the [AWS Credentials](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html).

* [Install the Docker](https://docs.docker.com/get-docker/)(skip if already installed).


### Installing

A step by step series of examples that tell you how to get a development env running.

Application cloning

```
git clone https://github.com/maimitp9/greeting-bot.git
```

Setting environment variables

> For **BOT_OAUTH_TOKEN**, get it from Slack API under OAuth & Permissions menu

> For **VERIFICATION_TOKEN**, get it from Slack API under Basic Information menu

```
export BOT_OAUTH_TOKEN='bot oauth token'
export VERIFICATION_TOKEN='verification_token'
```

Pull the docker image ***lambci/lambda:ruby2.7*** from [DockerHub](https://hub.docker.com/r/lambci/lambda)

> Make sure you have installed Docker

```
docker pull lambci/lambda:ruby2.7
```

Running lambda function in development environment

- To verfy request come from Slack

```
docker run \
-e VERIFICATION_TOKEN=$VERIFICATION_TOKEN \
--rm -v "$PWD":/var/task lambci/lambda:ruby2.7 \
greeting_bot.GreetingBot.main \
'{"type": "url_verification","token": "verification_token","challenge": "challenge"}'
```

- Send message to slack
```
 docker run \
  -e BOT_OAUTH_TOKEN=$BOT_OAUTH_TOKEN \
  --rm -v "$PWD":/var/task lambci/lambda:ruby2.7 \
  greeting_bot.GreetingBot.main \
  '{"type": "event_callback","event":{"type":"app_mention","text":"hello!","channel":"greeting-channel"}}'
```

## Deployment

Add additional notes about how to upload in AWS Lambda [read more](https://docs.aws.amazon.com/lambda/latest/dg/ruby-package.html)

Create Zip file for deployment


```
zip -r function.zip greeting_bot.rb
```

Upload zip file to AWS lambda

> Make sure you have installed [AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and configured the [AWS Credentials](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html).

```
aws lambda update-function-code --function-name slack-greeting-bot --zip-file fileb://function.zip
```

>  Add profile if required --profile profile-name

## Author

* **Maimit Patel** - [GitHub profile](https://github.com/maimitp9)
