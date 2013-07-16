require 'Provider'
require 'FacebookProvider'
require 'GoogleProvider'
require 'FourSquareProvider'
require 'httpclient'
require 'json'
class EventsController < ApplicationController  
  before_filter :checklogin
  #TODO clean up this file with functions we don't need
  #It seems like we should keep all of these functions 
  
=begin
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @events }
    end
  end
=end
  
  
  # GET /events/1
  # GET /events/1.json
  def show
    #TODO this should query based the id being equal to the id in the events table on the session[:userid] being equal to the user_id column in the table
    @event = Event.find(params[:id])


    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    #TODO we should be reading in an id parameter for the venue id, we can use the VenueController's class function to get information about the venue and display the _venue_info partial in the app/shared directory to display the . 
    venue_id = params[:fs_id]

    #@venue = VenuesController.getVenueInformation(foursquare_id, @tokensHash[FourSquareProvider.service_name].access_token)
    oauth_token = @tokensHash[FourSquareProvider.service_name].access_token
    version = Time.now.strftime("%Y%m%d")
    client  = HTTPClient.new
    request_url = "https://api.foursquare.com/v2/venues/#{venue_id}?oauth_token=#{oauth_token}&v=#{version}"
    @response = client.get(request_url)
    @responseJson = JSON.parse(response.body)


    #if @tokenHash[FacebookProvider.service_name]
    #    friends = FacebookProvider.returnFriendsList(@tokensHash[FacebookProvider.service_name])
    #else
      
    #end
    
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, :notice => 'Event was successfully created.' }
        format.json { render :json => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
