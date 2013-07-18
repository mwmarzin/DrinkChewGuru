require 'FourSquareProvider'
require 'Venue'
require 'json'

class VenuesController < ApplicationController
  before_filter :checklogin
  
  def search
    #TODO display a page that the user can user to search foursquare for a venue
    #the controller doesn't do much here
    #show redirect to the users page when
    @venues = Array.new

    if (params[:location] || params[:query])
      @location=params[:location]
      @query=params[:query]
      client = HTTPClient.new
      version = Time.now.strftime("%Y%m%d")
      oauth_token = @tokensHash[FourSquareProvider.service_name].access_token
      @url = "https://api.foursquare.com/v2/venues/search?"
      
      if (!params[:location].nil? && !params[:location].blank?)
        #replace the spaces with a %20 to escape the html
        @location = @location.sub(" ", "%20")
        @url = @url + "near=#{@location}"
      end
      
      if (!params[:query].nil? && !params[:query].blank?)
        #replace the spaces with a %20 to escape the html
        @query = @quer.sub(" ", "%20")
        @url = @url + "&query=#{@query}"
      end
      @url = @url + "&oauth_token=#{oauth_token}&v=#{version}"
      @response = client.get(@url)
     
      # if @response.code == "200"

      @responseJson = JSON.parse(@response.body)
      if (@responseJson["response"] && @responseJson["response"])
        @responseJson["response"]["venues"].each do |venueJson|
          venue = VenuesController.convertJsonToVenue(venueJson)
          @venues.push(venue)
        end
      end

      # search_venue = @responseJson["response"]["venues"]
      # @venue_name=search_venue["name"]
      #  @responseJson["response"]["venues"][0].each do |result|
      #   @venue_name =    result["name"]
      # end
      #puts @responseJson
      # end
    end
      
   
  end

  def results
    @location=params[:location]

    client = HTTPClient.new
    version = Time.now.strftime("%Y%m%d")
    oauth_token = temp_token = "ISH5O3EJNGHGI5O4PRKF5GXADOM3S4K4AUJWVMDWLS35TVOH"
      
    @url = "https://api.foursquare.com/v2/venues/search?ll=40.7,-74&oauth_token=#{oauth_token}&v=#{version}"
    @result_url=   client.get(@url)


    #TODO use the information entered in the "search" page to make a query string that can be used to query FourSquare for venues
    #Should use a new method in the FourSquareProvider class to take a parameter and have it make the query string that can then use httpclient to do a get data.
    #display the results in a page
    #should redirect "/venue/:id" where :id is the FourSquare Venue Id
    #we could also include a direct link to create an event here which redirects to /event/new/:id
    
    #TODO we could condense this page into the the same as search by displaying results if they exist
      
      
  end

  
  def display
    #TODO when a user clicks on a search results, it sends them to this page with params[:id] set to the FourSquare Venue ID
    #This page shows as much information as we can get about the venue 
    #should have a link to create a new event at this location which redirects to "/event/new/:id"
    if (@tokensHash[FourSquareProvider.service_name])
      foursquare_id = params[:id]
      @venue = VenuesController.getVenueInformation(foursquare_id, @tokensHash[FourSquareProvider.service_name].access_token)
    else
      flash[:alert] = "We need a token from FourSquare for you to use this page. Please sign in with FourSquare."
      redirect_to("/oauth")
    end
  end
  
  def self.getVenueInformation(venue_id="", oauth_token="")
    client = HTTPClient.new
    version = Time.now.strftime("%Y%m%d")
    #this is for testing
    if oauth_token == ""
      oauth_token = temp_token = "ISH5O3EJNGHGI5O4PRKF5GXADOM3S4K4AUJWVMDWLS35TVOH"
    end
    
    request_url = "https://api.foursquare.com/v2/venues/#{venue_id}?oauth_token=#{oauth_token}&v=#{version}"
    response = client.get(request_url)
    responseJson = JSON.parse(response.body)
    #TODO needs more error checking!
    if (responseJson["meta"]["code"] && (responseJson["meta"]["code"] == 200))
      venueJson = responseJson["response"]["venue"]
      venue = convertJsonToVenue(venueJson)
      return venue
    else
      raise "Error returned from FourSquare API."
    end 
  end
  
  def self.convertJsonToVenue(venueJson = "")
    venue = Venue.new
    venue.id = venueJson["id"] 
    venue.name = venueJson["name"] 
    locationJson = venueJson["location"]
    venue.location = Location.new
    venue.location.address = locationJson["address"]
    venue.location.zip = locationJson["postalCode"]
    venue.location.city = locationJson["city"]
    venue.location.state = locationJson["state"]
    venue.location.country = locationJson["country"]
    venue.likeCount = venueJson["likes"]["count"] unless venueJson["likes"].nil?
    
    venue.tips = Array.new
    tipsJson = venueJson["tips"]
    if (!tipsJson.nil? && tipsJson["count"] && tipsJson["count"] > 0)
      tipsJson = tipsJson["groups"]      
      tipsJson.each do |group|
        group["items"].each do |tip|
          venue.tips.push(tip["text"])
        end
      end
    end
    return venue
  end
  
end
