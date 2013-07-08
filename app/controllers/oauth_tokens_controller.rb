require 'Provider'
require 'FacebookProvider'
require 'GoogleProvider'
require 'FourSquareProvider'
require 'httpclient'
require 'json'
class OauthTokensController < ApplicationController

  def index
    if(session[:userid])
      @user = User.find(session[:userid])
      #TODO need to add something to validate if tokens are still valid and refresh the token if needed.
      @tokensHash = @user.oauth_tokens.index_by(&:provider)
      respond_to do |format|
        format.html # index.html.erb
      end
    else
      redirect_to "/login", :alert => "Please sign in."
    end
  end

  def call
    @provider = getProviderClass(params[:provider])

    redirect_to(@provider.getOAuthTokenRequestURL())
  end

  # POST /oauth_tokens
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
      @requestURL = ""
      if params[:provider] == "Facebook"  
        headers={"access_token"=>@tokenHash[:access_token]}
        @requestURL = "https://graph.facebook.com/me/friends?fields=first_name,picture&limit=5"
        @response = client.get(@requestURL,headers)
      elsif params[:provider] == "Google"
        headers={"Authorization: Bearer"=>@tokenHash[:access_token]}
        @requestURL = "https://www.googleapis.com/calendar/v3/users/me/calendarList?minAccessRole=writer"
        @response = client.get(@requestURL,headers)
      elsif params[:provider] == "FourSquare"
        @requestURL = "https://api.foursquare.com/v2/lists/self/todos?oauth_token=#{@tokenHash[:access_token]}"
        @response = client.get(@requestURL)
      end

      @responseJSON = JSON.parse(@response.body)
      
      #TODO:change the 1 to the userid in session
      OauthToken.create({:provider => @tokenHash[:provider], :access_token => @tokenHash[:access_token],
        :userid => 1, :expires_in =>  @tokenHash[:expires_in], :refresh_token =>  @tokenHash[:refresh_token]})
    
      respond_to do |format|
        format.html # create.html.erb
      end
        
      rescue => e
        redirect_to(:controller => "oauth_tokens", :action =>"index", :alert => "Sorry! We encountered an error getting data from #{params[:provider]}. If thise continues. Please contact an admin.")
        logger.info 'ERROR on create in oauth tokens'
        logger.info e.message
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