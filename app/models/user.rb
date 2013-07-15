require 'Provider'
require 'FacebookProvider'
require 'GoogleProvider'
require 'FourSquareProvider'
require 'httpclient'
require 'json'

class User < ActiveRecord::Base
  has_many :oauth_tokens, :dependent => :destroy
  has_many :events, :dependent => :destroy
  attr_accessible :email, :first_name, :identity_url, :last_name
  accepts_nested_attributes_for :oauth_tokens, :events
  
  
  def getFriendsList()
    tokenHash = @user.oauth_tokens.index_by(&:provider)
    token = tokenHash[FacebookProvider.service_name]
    
    friends = Array.new
    client = HTTPClient.new
    headers={"access_token"=>token}
    @requestURL = "https://graph.facebook.com/me/friends?fields=first_name,picture"
    @response = client.get(@requestURL,headers)
    
    
  end
  
  def getTodos()
    tokenHash = @user.oauth_tokens.index_by(&:provider)
    token = tokenHash[FourSquareProvider.service_name]
    todos = Array.new
    client = HTTPClient.new
    version = Time.now.strftime("%Y%m%d")
    
    request_url = "https://api.foursquare.com/v2/users/self/todos?sort=recent&oauth_token=#{token}&v=#{version}"
    response = client.get(request_url)
    responseJson = JSON.parse(response.body)
    #TODO need more error checking to make sure these imbedded fields exist
    if (responseJson["meta"]["code"] && (responseJson["meta"]["code"] == 200))
      responseJson["response"]["todos"]["items"].each do |todo|
        venueJson = todo["tip"]["venue"]
        todos.push(VenuesController.convertJsonToVenue(venueJson))
      end
    else
      raise "Error returned from FourSquare API."
    end
    return todos
  end
end
