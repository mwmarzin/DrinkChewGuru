require 'Provider'
class FacebookProvider < Provider
  def initialize()
    super()
    @client_id = "181012372060361"
    @client_secret = "6e799ece526d2b8c9b9645a575eeaa84"
    @redirect_uri = "#{Rails.root.to_s}/oauth/Facebook/callback"
    @access_url = "https://www.facebook.com/dialog/oauth/"
    @state = rand(99999)
    @perms = "create_event"
  end
end
  