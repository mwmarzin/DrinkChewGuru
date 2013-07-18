require 'Provider'
require 'FacebookProvider'
require 'GoogleProvider'
require 'FourSquareProvider'
require 'httpclient'
require 'Friend'
require 'json'

class User < ActiveRecord::Base
  has_many :oauth_tokens, :dependent => :destroy
  has_many :events, :dependent => :destroy
  attr_accessible :email, :first_name, :identity_url, :last_name
  accepts_nested_attributes_for :oauth_tokens, :events
  
  #getFriendsList: uses the user's token for Facebook to query the friends API to return the entire friendslist
  #Returns: an Array filled with Friend objects
  def getFriendsList()
    #convert the oauth_tokens array to a hash base on the provider (to easily access the tokens)
    tokenHash = oauth_tokens.index_by(&:provider)
    #get the Facebook Token
    token = tokenHash[FacebookProvider.service_name].access_token
    
    #Define the friends return array and create an HTTPClient.
    friends = Array.new
    client = HTTPClient.new
    
    #Make a HTTP GET Request from the Facebook friends API to get the fields we'll be using in our app
    headers={"access_token"=>token}
    requestURL = "https://graph.facebook.com/me/friends?fields=id,first_name,last_name,picture"
    response = client.get(requestURL,headers)    
    responseJson = JSON.parse(response.body)
    
    #If the data tag is in the returned JSON, we know we got some data bacl
    if responseJson["data"]
      friendsJson = responseJson["data"]
      friendsJson.each do |friendJson|
        friend = Friend.new
        friend.provider = "Facebook"
        friend.providerid = friendJson["id"]
        friend.first_name = friendJson["first_name"]
        friend.last_name = friendJson["last_name"]
        if friendJson["picture"]["data"] && friendJson["picture"]["data"]["url"]
          friend.picture_url = friendJson["picture"]["data"]["url"]
        end
        friends.push(friend)
      end
    #Otherwise raise an excpetion to be handled by the caller.
    else 
      raise "Error getting data from Facebook API"
    end
    return friends
  end
  
  #getTodos: Use the user's FourSquare token to query their To-Do list of places they want to go 
  #Returns: An Array of Venue Items (from the To-Do List)
  def getTodos()
    tokenHash = oauth_tokens.index_by(&:provider)
    token = tokenHash[FourSquareProvider.service_name].access_token
    todos = Array.new
    client = HTTPClient.new
    version = Time.now.strftime("%Y%m%d")
    
    request_url = "https://api.foursquare.com/v2/users/self/todos?sort=recent&oauth_token=#{token}&v=#{version}"
    response = client.get(request_url)
    responseJson = JSON.parse(response.body)
    #check to make sure embedded fields exist and if so, the code is 200 (SUCCESS!) 
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
