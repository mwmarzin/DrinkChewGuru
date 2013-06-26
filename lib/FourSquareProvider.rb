require 'Provider'
class FourSquareProvider < Provider
  @client_id = "EXE00JNPDHGUAQXEDXMCCKQ0KOCY2RKT0JVGSAIUZC0LDDDB"
  @client_secret = "KJX1SGYG1ENHBQ02O2B4AUA1R3OFALH1I2MBTNLOOA54NWWX"
  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/FourSquare/callback"
  @service_name = "FourSquare"
  @exchange_url = ""

  @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/Facebook/callback"
  @access_url = "https://www.facebook.com/dialog/oauth/"
  @exchange_url = "https://graph.facebook.com/oauth/access_token"
  @perms = "create_event,user_about_me,user_birthday,user_likes,user_events,"
  @state = rand(99999)
  @service_name = "Facebook"



  def self.returnToken(responseBody)
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