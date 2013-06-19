require 'Provider'
class FacebookProvider < Provider
  def initialize()
    super()
    @client_id = "181012372060361"
    @client_secret = "6e799ece526d2b8c9b9645a575eeaa84"
    @redirect_uri = "http://drinkchewguru.elasticbeanstalk.com/oauth/Facebook/callback"
    @access_url = "https://www.facebook.com/dialog/oauth/"
    @exchange_url = "https://graph.facebook.com/oauth/access_token"
    @state = rand(99999)
    @perms = "create_event"
  end
end
  