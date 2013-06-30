require 'Provider'
class GoogleProvider < Provider
  @client_id = "307247955504.apps.googleusercontent.com"
  @client_secret = "W1kRezogoDm61Gmyp_gqgI7y"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/Google/callback"
  @access_url = "https://accounts.google.com/o/oauth2/auth"
  @exchange_url = "https://accounts.google.com/o/oauth2/token"
  #permissions (Google calls this scope)
  @perms = "https://www.googleapis.com/auth/calendar https://www.google.com/m8/feeds/ https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.profile"
  @state = rand(99999)
  
  def self.getOAuthTokenRequestURL()
    @request = "#{@access_url}?"       +
      "client_id=#{@client_id}"        +
      "&redirect_uri=#{@redirect_uri}" +
      "&scope=#{@perms}"               +
      "&response_type=code"            +
      "&state=#{@state}"               +
      "&approval_prompt=force"         +
      "&access_type=offline"
  end
  
  def self.getOAuthExchangeTokenURL(code)
    @request = "#{@exchange_url}?" + 
      "client_id=#{@client_id}" +
      "&redirect_uri=#{@redirect_uri}" +
      "&client_secret=#{@client_secret}" +
      "&code=#{code}"
  end
  
  def self.returnToken(response, state=0)
    if response.header["Content-Type"] == "application/json"     
      responseArray = response.body.split("&")
      tokenParam = responseArray[0].split("=")
      expiresParam = responseArray[1].split("=")
      if(tokenParam[0] == "access_token")
        access_token = tokenParam[1]
        expires_in = tokenParam[2]
        provider = @service_name
      else
        return ""
      end
      return {:access_token => access_token, :expires_in => expires_in, :provider => provider, :refresh_token => ""}
    else
      return ""
    end
  end

end
  