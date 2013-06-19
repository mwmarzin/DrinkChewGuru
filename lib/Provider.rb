class Provider
  attr_accessor :client_id, :client_secret, :redirect_uri, :access_url, :state
  
  def initalize ()
    @state = rand(99999)
  end
  
  def getOAuthTokenRequestURL()
    @request = "#{@access_url}?" +
      "client_id=#{@client_id}" +
      "&redirect_uri=#{@redirect_uri}" +
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
