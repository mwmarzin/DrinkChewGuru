class Provider
  class << self; attr_accessor :client_id, :client_secret, :redirect_uri, :access_url,
  :exchange_url, :service_name end
  def initalize (host = "")
    @redirect_uri += host
  end
  
  def self.getOAuthTokenRequestURL()
    state = rand(99999)
    @request = "#{@access_url}?" +
      "client_id=#{@client_id}" +
      "&redirect_uri=#{@redirect_uri}" +
      "&state=#{state}"+
      "&scope=#{@perms}"
  end
  
  def self.getOAuthExchangeTokenURL(code)
    @request = "#{@exchange_url}?" + 
      "client_id=#{@client_id}" +
      "&redirect_uri=#{@redirect_uri}" +
      "&client_secret=#{@client_secret}" +
      "&code=#{code}"
  end
  
  def self.getOAuthParamArray(scope = nil)
    
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
