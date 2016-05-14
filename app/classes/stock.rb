require 'net/http'

class Stock
  attr_accessor :context, :company

  def initialize(context)
    @context = context
  end

  def query
    keyword = @context["company"]
    uri = URI("https://api.thomsonreuters.com/permid/search?q=#{keyword}&access-token=GxNEkGUmGJXAeiJpBu3HrYON9oZUWsvY")
    resp = Net::HTTP.get_response(uri)
    json = JSON.parse resp.body
    @company = json["result"]["organizations"]["entities"].first
  end
end
