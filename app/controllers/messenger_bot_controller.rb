require 'wit'

class MessengerBotController < ApplicationController
  before_action :set_wit
  def message(event, sender)
    @user = User.find_or_create_by(facebook_uuid: event["sender"]["id"])
    sender.get_profile[:body].each do |key, value|
      next if key == 'timezone'
      @user.update_attribute(key, value)
    end
    @user.save
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
      credit_card_query: -> (session_id, context) {
        @reply = {
          "attachment": {
            "type": "template",
            "payload": {
              "template_type": "generic",
              "elements": [
                {
                  "title": "RHB WORLD MASTERCARD CREDIT CARD",
                  "subtitle": "Enjoy up to 6% Cash Back whenever you travel, fill petrol and dine. Enjoy the World wherever you are, local or overseas, it will be rewarding.",
                  "image_url": "http://www.rhbgroup.com/~/media/images/malaysia/product-and-services/personal/cards/credit-cards/rhb-world-mastercard/card-1.ashx?h=126&la=en&w=200",
                  "buttons": [{
                    "type": "web_url",
                    "url": "http://www.rhbgroup.com/products-and-services/personal/cards/credit-cards/rhb-world-mastercard",
                    "title": "Web url"
                  }]
                }, {
                  "title": "RHB VISA INFINITE CREDIT CARD",
                  "subtitle": "Earn 5X Reward Points when you spend overseas, enjoy complimentary green fee on golfing and experience travel comfort reserved only for the elite. Discover a world of Infinite possibilities unlike any other.",
                  "image_url": "http://www.rhbgroup.com/~/media/images/malaysia/product-and-services/personal/cards/credit-cards/infinite-credit-card/card-1.ashx?h=126&la=en&w=200",
                  "buttons": [{
                    "type": "web_url",
                    "url": "http://www.rhbgroup.com/products-and-services/personal/cards/credit-cards/rhb-visa-infinite-credit-card",
                    "title": "Web url"
                  }]
                }, {
                  "title": "Maybankard Manchester United Visa Card",
                  "subtitle": "Own the Card of Champions!",
                  "image_url": "http://www.maybank2u.com.my/WebBank/manU_tn.png",
                  "buttons": [{
                    "type": "web_url",
                    "url": "http://www.maybank2u.com.my/mbb_info/m2u/public/personalDetail04.do?channelId=&programId=CRD01-CreditCards&chCatId=/mbb/Personal/CRD-Cards&cntTypeId=0&cntKey=537003127",
                    "title": "Web url"
                  }]
                }, {
                  "title": "Maybank 2 Gold Card",
                  "subtitle": "2 is all you need",
                  "image_url": "http://www.maybank2u.com.my/WebBank/dualGold_tn.png",
                  "buttons": [{
                    "type": "web_url",
                    "url": "http://www.maybank2u.com.my/mbb_info/m2u/public/personalDetail04.do?channelId=&programId=CRD01-CreditCards&chCatId=/mbb/Personal/CRD-Cards&cntTypeId=0&cntKey=190064",
                    "title": "Web url"
                  }]
                }
              ]
            }
          }
        }
      },
      :user_summary => -> (session_id, context){
        @reply = {
          "attachment": {
            "type": "template",
            "payload": {
              "template_type": "generic",
              "elements": [{
                "title": "#{@user.first_name} #{@user.last_name}",
                "subtitle": @user.gender,
                "image_url": @user.profile_pic
              }]
            }
          }
        }
      },
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
        stock_quote = StockQuote::Stock.quote(stock.company["primaryTicker"])
        @reply = {
          "attachment": {
            "type": "template",
            "payload": {
              "template_type": "generic",
              "elements": [{
                "title": "#{stock.company["organizationName"]}, #{stock.company["primaryTicker"]}",
                "subtitle": "Ask: #{stock_quote.ask}, Change: #{stock_quote.change}(#{stock_quote.changein_percent})",
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
