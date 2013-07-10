class VenuesController < ApplicationController
  before_filter :checklogin
  
  def search
    #TODO display a page that the user can user to search foursquare for a venue
    #the controller doesn't do much here
    #show redirect to the users page when
  end

  def results
    #TODO use the information entered in the "search" page to make a query string that can be used to query FourSquare for venues
    #Should use a new method in the FourSquareProvider class to take a parameter and have it make the query string that can then use httpclient to do a get data.
    #display the results in a page
    #should redirect "/venue/:id" where :id is the FourSquare Venue Id
    #we could also include a direct link to create an event here which redirects to /event/new/:id
  end

  
  def display
    #TODO when a user clicks on a search results, it sends them to this page with params[:id] set to the FourSquare Venue ID
    #This page shows as much information as we can get about the venue 
    #should have a link to create a new event at this location which redirects to "/event/new/:id"
  end
end
