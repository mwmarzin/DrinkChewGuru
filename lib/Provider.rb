require 'httpclient'
require 'json'

class Provider
  class << self; attr_accessor :client_id, :client_secret, :redirect_uri, :access_url,
  :exchange_url, :service_name end
  
  def self.getOAuthTokenRequestURL()
    raise "This function should be overwritten by a child!"
  end
  
  def self.getOAuthExchangeTokenURL(code)
    raise "This function should be overwritten by a child!"
  end
  
  def self.getOAuthParamArray(scope = nil)
    raise "This function should be overwritten by a child!"
  end
  
  def self.returnToken(responseBody, state=0)
    raise "This function should be overwritten by a child!"
  end
  
end
