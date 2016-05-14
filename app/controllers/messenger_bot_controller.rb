require 'wit'

class MessengerBotController < ApplicationController
  def message(event, sender)
    wit = Wit.new access_token, actions
    sender_id = event["sender"]["id"]
    text = event["message"]["text"]
    wit.run_actions sender_id, text
    sender.reply(@reply)
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    payload = event["postback"]["payload"]
    puts "================================================"
    puts payload
    puts "================================================"
    payloads = payload.split(',')
    case payloads[0]
    when 'buy'
      sender.reply("How much?");
    end
  end

  private

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
                }, {
                  "type": "postback",
                  "title": "Buy Stock",
                  "payload": "buy,#{stock.company["primaryTicker"]}",
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
