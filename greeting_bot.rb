# for development

#  docker run \
#   -e BOT_OAUTH_TOKEN=$BOT_OAUTH_TOKEN \
#   --rm -v "$PWD":/var/task lambci/lambda:ruby2.7 \
#   greeting_bot.GreetingBot.main \
#   '{"type": "event_callback","event":{"type":"app_mention","text":"hello!","channel":"greeting-channel"}}'

# for varification

# docker run \
# -e BOT_OAUTH_TOKEN=$BOT_OAUTH_TOKEN \
# -e VERIFICATION_TOKEN=$VERIFICATION_TOKEN \
# --rm -v "$PWD":/var/task lambci/lambda:ruby2.7 \
# greeting_bot.GreetingBot.main \
# '{"type": "url_verification","token": "token","challenge": "u5ijvVH71L7iPGJQLwSK1P7EnpMNUsE6fTEDIlbQzIqzfuFaQEZO"}'

class GreetingBot
  def self.main(event:, context:)
    new.run(event)
  end

  def run(event)
    case event['type']
    when 'url_verification'
      verify(event['token'], event['challenge'])
    when 'event_callback'
      if event['event']['type'] == 'app_mention'
        process(event['event']['text'], event['event']['channel'])
      end
    end
  end

  private

  # Verify request from the slack
  def verify(token, challenge)
    if token == ENV['VERIFICATION_TOKEN']
      { body: { challenge: challenge } }
    else
      { body: 'Invalid token' }
    end
  end

  def process(text, channel)
    body = if text.strip.downcase.include?('hello')
             'Hi, How are you?'
           else
             'How may I help you?'
           end
    send_message(body, channel)
  end

  # Slack API response to the mentioned channel
  def send_message(text, channel)
    uri = URI('https://slack.com/api/chat.postMessage')
    params = {
      token: ENV['BOT_OAUTH_TOKEN'],
      text: text,
      channel: channel
    }
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get_response(uri)
  end
end
