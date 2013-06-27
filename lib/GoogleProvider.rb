require 'Provider'
class GoogleProvider < Provider
  @client_id = "307247955504.apps.googleusercontent.com"
  @client_secret = "W1kRezogoDm61Gmyp_gqgI7y"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/privacy"
  @access_url = "https://accounts.google.com/o/oauth2/auth"
  #I am uncertain if this is where I need to include the URL that grants us the authorization code..
  #I understand that is what the Provider class is for but it seems like the Google URL contains different stuff
  
  #"https://accounts.google.com/o/oauth2/auth?
  #scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.email+https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fuserinfo.profile&
  #state=%2Fprofile&
  #redirect_uri=https%3A%2F%2Foauth2-login-demo.appspot.com%2Fcode&
  #response_type=code&
  #client_id=307247955504.apps.googleusercontent.com&
  #approval_prompt=auto"
  
  #The following is left from the code that Matt wrote for the FacebookProvider
  #@exchange_url = "https://graph.facebook.com/oauth/access_token"
  #@perms = "create_event,user_about_me,user_birthday,user_likes,user_events,"
  #@state = rand(99999)
  
  def self.validateOAuthToken(responseBody, state=0)
    #TODO:set this up to return the same hash as facebook, or find a better way of returning data.
	#Google responds to a successful request with a JSON array
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
  