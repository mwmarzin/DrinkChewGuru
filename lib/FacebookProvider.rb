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
  
  def self.validateOAuthToken(responseBody)
    responseArray = responseBody.split("&")
    tokenParam = responseArray[0].split("=")
    token = false
    if(tokenParam[0] == "access_token")
      token = tokenParam[1]
    else
      token = false
    end
    return token
  end
end
  