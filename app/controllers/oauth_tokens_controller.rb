require 'Provider'
require 'FacebookProvider'
require 'GoogleProvider'
require 'FourSquareProvider'
require 'httpclient'
require 'json'
class OauthTokensController < ApplicationController

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def call
    @provider = getProviderClass(params[:provider])

    redirect_to(@provider.getOAuthTokenRequestURL())
  end

  # POST /oauth_tokens
  # POST /oauth_tokens.json
  def create
    begin
      #TODO:need code for validating the state!!!
      @provider = getProviderClass(params[:provider])
    
      @code = params[:code]
      @state = params[:state]
    
      @exchangeURL = @provider.getOAuthExchangeTokenURL(@code)
      client = HTTPClient.new
    
      #TODO there should be a better way to handle this then to hardcode if the provider wants a POST or a GET. Maybe something in the provider classes?
      if params[:provider] == "Google"
        @tokenResponse = client.post(@provider.exchange_url, @provider.getOAuthExchangeParams(@code))
      else
        @tokenResponse = client.get(@exchangeURL)
      end
    
      @tokenHash = @provider.returnToken(@tokenResponse)
    
      #The next couple lines are just to test getting data with the tokens we've just retrieved from the provider
      if params[:provider] == "Facebook"  
        headers={"access_token"=>@tokenHash[:access_token]}
        @response = client.get("https://graph.facebook.com/me/friends?fields=first_name,picture&limit=5",headers)
      elsif params[:provider] == "Google"
        headers={"Authorization: Bearer"=>@tokenHash[:access_token]}
        @response = client.get("https://www.googleapis.com/calendar/v3/users/me/calendarList?minAccessRole=writer",headers)
      elsif params[:provider] == "FourSquare"
        #add in some sort of a test call to the FourSquare API
      end

      @responseJSON = JSON.parse(@response.body)
      
    rescue => e
          redirect_to(:controller => "oauth_tokens", :action =>"index", :error => "Sorry! We encountered an error getting data from #{params[:provider]}. If thise continues. Please contact an admin.")
    end
    #TODO:change the 1 to the userid in session
    OauthToken.create({:provider => @tokenHash[:provider], :access_token => @tokenHash[:access_token],
                       :userid => 1, :expires_in =>  @tokenHash[:expires_in], :refresh_token =>  @tokenHash[:refresh_token]})
    
    respond_to do |format|
      format.html # create.html.erb
    end
  end

  def getProviderClass(providerName)
    if providerName == "Facebook"
      provider = FacebookProvider
    elsif providerName == "Google"
      provider = GoogleProvider
    elsif providerName == "FourSquare"
      provider = FourSquareProvider
    else
      raise "WHOA! I don't know who this is!"
    end
    
    return provider
  end

end