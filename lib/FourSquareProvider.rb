require 'Provider'
class FourSquareProvider < Provider
  @client_id = "EXE00JNPDHGUAQXEDXMCCKQ0KOCY2RKT0JVGSAIUZC0LDDDB"
  @client_secret = "KJX1SGYG1ENHBQ02O2B4AUA1R3OFALH1I2MBTNLOOA54NWWX"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/FourSquare/callback"
  @service_name = "FourSquare"
  @access_url = "https://foursquare.com/oauth2/authenticate"
  @exchange_url = "https://foursquare.com/oauth2/access_token"
  @perms = ""
  @state = 0

  def self.getOAuthTokenRequestURL()
    session[:state] = 0
    @request = "#{@access_url}?"       +
      "client_id=#{@client_id}"        +
      "&redirect_uri=#{@redirect_uri}" +
      "&response_type=code"
  end

  def self.returnToken(response, state=0)
    responseJson =  JSON.parse(response.body)
    #if responseJson.has_key?(:access_token)
      access_token = responseJson["access_token"]
      expires_in = ""
      refresh_token = ""
      #else
      #raise "Error returned from FourSquare"
      #end
    return {:access_token => access_token, :expires_in => expires_in, :provider => @service_name, :refresh_token => refresh_token}
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
  
  #TODO need to correctly stub this out.
  def self.getOAuthParamArray(scope = nil)
    raise "FourSquare Provider Needs This Function!"
  end
  
end