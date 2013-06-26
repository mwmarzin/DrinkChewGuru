require 'Provider'
class FacebookProvider < Provider
  @client_id = "181012372060361"
  @client_secret = "6e799ece526d2b8c9b9645a575eeaa84"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/Facebook/callback"
  @access_url = "https://www.facebook.com/dialog/oauth/"
  @exchange_url = "https://graph.facebook.com/oauth/access_token"
  @perms = "create_event,user_about_me,user_birthday,user_likes,user_events,"
  @state = rand(99999)
  @service_name = "Facebook"
  
  def self.getOAuthTokenRequestURL()
    @request = "#{@access_url}?" +
      "client_id=#{@client_id}" +
      "&redirect_uri=#{@redirect_uri}" +
      "&state=#{@state}"+
      "&scope=#{@perms}"
  end
  
  def self.getOAuthExchangeTokenURL(code)
    @request = "#{@exchange_url}?" + 
      "client_id=#{@client_id}" +
      "&redirect_uri=#{@redirect_uri}" +
      "&client_secret=#{@client_secret}" +
      "&code=#{code}"
  end
  
  def self.getOAuthParamArray(scope = nil)
    
    a = {"client_id" => "#{@access_url}",
         "redirect" => "#{@redirect_uri}",
         "state" => "#{@state}"
        }
    if !scope.nil? 
      a["scope"] = "#{scope}"
    end
    a
  end
  
  def self.returnToken(responseBody, state=0)
    responseArray = responseBody.split("&")
    tokenParam = responseArray[0].split("=")
    expiresParam = responseArray[1].split("=")
    if(tokenParam[0] == "access_token")
      access_token = tokenParam[1]
      expires_in = tokenParam[2]
      provider = @service_name
    else
      raise "error thrown"
    end
    return {:access_token => access_token, :expires_in => expires_in, :provider => provider, :refresh_token => ""}
  end
end