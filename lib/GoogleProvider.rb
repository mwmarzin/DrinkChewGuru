require 'Provider'
class GoogleProvider < Provider
  @client_id = "307247955504.apps.googleusercontent.com"
  @client_secret = "W1kRezogoDm61Gmyp_gqgI7y"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/Google/callback"
  #@access_url = "https://www.facebook.com/dialog/oauth/"
  #@exchange_url = "https://graph.facebook.com/oauth/access_token"
  #@perms = "create_event,user_about_me,user_birthday,user_likes,user_events,"
  #@state = rand(99999)
  
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
  