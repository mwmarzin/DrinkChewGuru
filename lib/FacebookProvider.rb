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
  
  def self.returnToken(responseBody, state=0)
    oauthToken = OauthToken.new
    responseArray = responseBody.split("&")
    tokenParam = responseArray[0].split("=")
    expiresParam = responseArray[1].split("=")
    if(tokenParam[0] == "access_token")
      oauthToken.access_token = tokenParam[1]
      oauthToken.expire_time = tokenParam[2]
      oauthToken.provider = @service_name
    else
      raise "error thrown"
    end
    return oauthToken
  end
end