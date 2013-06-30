require 'Provider'
class GoogleProvider < Provider
  @client_id = "307247955504.apps.googleusercontent.com"
  @client_secret = "W1kRezogoDm61Gmyp_gqgI7y"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/Google/callback"
  @access_url = "https://accounts.google.com/o/oauth2/auth"
  @exchange_url = "https://accounts.google.com/o/oauth2/token"
  #permissions (Google calls this scope)
  @perms = "https://www.googleapis.com/auth/calendar https://www.google.com/m8/feeds https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.profile"
  @service_name = "Google"
  
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
      responseJson =  JSON.parse(response.body)
      access_token = responseJson["access_token"]
      expires_in = responseJson["expires_in"]
      refresh_token = responseJson["refresh_token"]
      return {:access_token => access_token, :expires_in => expires_in, :provider => @service_name, :refresh_token => refresh_token}
  end

end
  