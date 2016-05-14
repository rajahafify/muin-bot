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
    case payload
    when :something
      #ex) process sender.reply({text: "button click event!"})
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
        s = Stock.new(context)
        s.query
        p s.company
        @reply = {
          "attachment": {
            "type": "template",
            "payload": {
              "template_type": "generic",
              "elements": [{
                "title": "Company name",
                "subtitle": "Element #1 of an hscroll",
                "image_url": "http://messengerdemo.parseapp.com/img/rift.png",
                "buttons": [{
                  "type": "web_url",
                  "url": "https://www.messenger.com/",
                  "title": "Web url"
                }, {
                  "type": "postback",
                  "title": "Postback",
                  "payload": "Payload for first element in a generic bubble",
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
