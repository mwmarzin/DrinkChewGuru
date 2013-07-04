require 'Provider'
class FourSquareProvider < Provider
  @client_id = "EXE00JNPDHGUAQXEDXMCCKQ0KOCY2RKT0JVGSAIUZC0LDDDB"
  @client_secret = "KJX1SGYG1ENHBQ02O2B4AUA1R3OFALH1I2MBTNLOOA54NWWX"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/FourSquare/callback"
  @service_name = "FourSquare"
  @exchange_url = ""
  
  @access_url = "https://foursquare.com/oauth2/authenticate"
  @exchange_url = "https://foursquare.com/oauth2/access_token"
  @perms = "create_event,user_about_me,user_birthday,user_likes,user_events"
  @state = rand(99999)

  def self.getOAuthTokenRequestURL()
    @request = "#{@access_url}?"       +
      "client_id=#{@client_id}"        +
      "&redirect_uri=#{@redirect_uri}" +
      "&response_type=code"
  end

  def self.returnToken(responseBody,state=0)
    #TODO set this up to return the same hash as facebook, or find a better way of returning data.
    token = OauthToken.new
    responseArray = responseBody.split("&")
    tokenParam = responseArray[0].split("=")
    token = false
    if(tokenParam[0] == "access_token")
      token.access_token = tokenParam[1]
    else
      token = false
    end
    return token
  end
    
  #TODO need to implement this
  def self.getOAuthExchangeTokenURL(code)
    @request = "#{@exchange_url}?" + 
      "client_id=#{@client_id}" +
      "&client_secret=#{@client_secret}" +
      "&grant_type=authorization_code"   +
      "&redirect_uri=#{@redirect_uri}"   +
      "&code=#{code}"
  end
  
  #TODO need to implement this
  def self.getOAuthParamArray(scope = nil)
    raise "FourSquare Provider Needs This Function!"
  end
  
end
def self.search_locations(text, latitude,longitude)
client.search_locations(:11 = > latitude, longitude, :query => text)
end
def self.client
client ||= Foursquare2::Client.new(:client_id => 'EXE00JNPDHGUAQXEDXMCCKQ0KOCY2RKT0JVGSAIUZC0LDDDB', :client_secret => 'KJX1SGYG1ENHBQ02O2B4AUA1R3OFALH1I2MBTNLOOA54NWWX')
end
end