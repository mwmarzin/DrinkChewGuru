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
  
  
  # GET /events/1
  # GET /events/1.json
  def show
    #TODO this should query based the id being equal to the id in the events table on the session[:userid] being equal to the user_id column in the table
    @event = Event.find(params[:event_id])


    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    #TODO we should be reading in an id parameter for the venue id, we can use the VenueController's class function to get information about the venue and display the _venue_info partial in the app/shared directory to display the . 
    @venue_id = params[:venue_id]
    @venue = VenuesController.getVenueInformation(@venue_id, @tokensHash[FourSquareProvider.service_name].access_token)

    @friends = @user.getFriendsList()
    @invitees = Array.new
    client = HTTPClient.new

    params.each do |key,value|
      if key.start_with?("invitee_")
        @invitees.push(key.split('_')[1])
      end
    end
    
    for i in 0..(@invitees.count - 1)
      if i == (@invitees.count - 1)
        @invite_string += @invitees[i]
      else
        @invite_string += @invitees[i] + ","
      end
    end

    #Get Calendar Information from Google API
    @headers=["Authorization: Bearer #{@tokensHash[GoogleProvider.service_name].access_token}"]
    @requestURL = "https://www.googleapis.com/calendar/v3/users/me/calendarList"
    #@requestURL = "https://www.googleapis.com/calendar/v3/users/me/calendarList?minAccessRole=writer"
    @response = client.get(@requestURL,@headers)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
  end

  # GET /events/1/edit
  def edit
    #@event = Event.find(params[:id])
    #TODO we should be reading in an id parameter for the venue id, we can use the VenueController's class function to get information about the venue and display the _venue_info partial in the app/shared directory to display the . 
    @event_id = params[:event_id]

    @venue = VenuesController.getVenueInformation(@event_id, @tokensHash[FourSquareProvider.service_name].access_token)

    @friends = @user.getFriendsList()
    @invitees = Array.new;

    params.each do |key,value|
      if key.start_with?("invitee_")
        @invitees.push(key.split('_')[1])
      end
    end
    
    for i in 0..(@invitees.count - 1)
      if i == (@invitees.count - 1)
        @invite_string += @invitees[i]
      else
        @invite_string += @invitees[i] + ","
      end
    end
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @event }
    end
    
    
  end

  # POST /events
  # POST /events.json
  def create
    
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
    #@event = Event.find(params[:id])
    
    venue_id = params[:venue_id]
    venue = VenuesController.getVenueInformation(venue_id, @tokensHash[FourSquareProvider.service_name].access_token)
    
    
    create_event_hash = createFacebookEvent(@tokensHash[FacebookProvider.service_name].access_token,
                                            name,
                                            venue)
    #self.createFacebookEvent(oauth_token="", name="Home", venue=Venue.new, start_time="2012-07-04T19:00:00-0700", end_time="2012-07-04T19:00:00-0700", description="", privacy_type = "FRIENDS")
    #@event = Event.create(:user_id => @user.id, :date_time, :email_invitees, :facebook_id, :facebook_invitees, :description, :google_id, :loacation_id)

=begin
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, :notice => 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @event.errors, :status => :unprocessable_entity }
      end
    end
=end
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
  
  def self.createFacebookEvent(oauth_token="", name="Home", venue=Venue.new, start_time="2012-07-04T19:00:00-0700", end_time="2012-07-04T19:00:00-0700", description="", privacy_type = "FRIENDS")
    client = HTTPClient.new
    returnHash = Hash.new
    postURL = "https://graph.facebook.com/me/events"
    headers={"access_token"=>oauth_token,
      "name"=>name,
      "start_time" => start_time,
      "end_time" =>  end_time,
      "location" => venue.to_s,
      "privacy_type" =>privacy_type,
      "description" => description
    }
    @response = client.post(postURL, headers)
    
    @eventJson = JSON.parse(response.body)
    if @eventJson["id"]
      returnHash["id"] = @eventJson["id"]
      returnHash["success"] = true
    else
      returnHash["success"] = false
    end
    
    return returnHash
  end

end
