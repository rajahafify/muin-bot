require 'wit'

class MessengerBotController < ApplicationController
  before_action :set_wit, :set_user
  def message(event, sender)
    sender_id = event["sender"]["id"]
    text = event["message"]["text"]
    @wit.run_actions sender_id, text
    sender.reply(@reply)
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    payload = event["postback"]["payload"]
    payloads = payload.split(',')
    case payloads[0]
    when 'buy'
      sender.reply(text: "How much?");
    end
  end

  private

  def set_wit
    @wit = Wit.new access_token, actions
  end

  def actions
    {
      :say => -> (session_id, context, msg) {
        @reply = { text: msg }
      },
      :merge => -> (session_id, context, entities, msg) {
        entities.each do |key, value|
          context[key] = value[0]["value"]
        end
        return context
      },
      :error => -> (session_id, context, error) {
        p error.message
      },
      :stock_query => -> (session_id, context){
        stock = Stock.new(context)
        stock.query
        @reply = {
          "attachment": {
            "type": "template",
            "payload": {
              "template_type": "generic",
              "elements": [{
                "title": stock.company["organizationName"],
                "subtitle": stock.company["primaryTicker"],
                "buttons": [{
                  "type": "web_url",
                  "url": stock.company["hasURL"],
                  "title": "Web url"
                }]
              }]
            }
          }
        }
      }
    }
  end

  def access_token
    'VX3FLU4RY2SXD3BVYPFBAE3LBHPW25RL'
  end
end
