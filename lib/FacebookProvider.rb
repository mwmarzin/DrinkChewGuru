require 'Provider'
class FacebookProvider < Provider
  def initialize()
    super()
    @client_id = "181012372060361"
    @client_secret = "6e799ece526d2b8c9b9645a575eeaa84"
    @redirect_uri = "#{Rails.root}/oauth"
    @access_url = "https://www.facebook.com/dialog/oauth/"
    @state = rand(99999)
    @perms = "create_event"
  end
  
  def getOAuthTokenRequestURL()
    @request = "#{@access_url}?" +
      "client_id=#{@client_id}" +
      "&redirect=#{@redirect_uri}" +
      "&state=#{@state}"+
      "&scope=#{@perms}"
  end
  
  def getOAuthParamArray(scope = nil)
    
    a = {"client_id" => "#{@access_url}",
         "redirect" => "#{@redirect_uri}",
         "state" => "#{@state}"
        }
    if !scope.nil? 
      a["scope"] = "#{scope}"
    end
    a
  end
end
  