require 'Provider'
require 'FacebookProvider'
require 'GoogleProvider'
require 'FourSquareProvider'
require 'httpclient'
require 'json'
require 'time'
class OauthTokensController < ApplicationController
  before_filter :checklogin, :only => [:index, :create]
  
  def index
    @userHasAllTokens = false
    #check to see that the user has tokens for all the Providers
    if ( @tokensHash[FourSquareProvider.service_name] &&
      @tokensHash[GoogleProvider.service_name]     &&
      @tokensHash[FacebookProvider.service_name] )
      @userHasAllTokens = true
    end
    if @userHasAllTokens == true
      flash[:notice] == "We're all signed in, enjoy using Drink.Chew.Guru!"
      redirect_to "/profile"
    else
      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end

  def call
    @provider = getProviderClass(params[:provider])

    redirect_to(@provider.getOAuthTokenRequestURL())
  end
  
  
  # POST /oauth_tokens
  def create
    #begin
    #TODO:need code for validating the state!!!
    @user = User.find(session[:userid])
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
      
    @token = @user.oauth_tokens.build({:provider => @tokenHash[:provider], :access_token => @tokenHash[:access_token],
      :expires_in =>  @tokenHash[:expires_in], :refresh_token =>  @tokenHash[:refresh_token]})
										  

<<<<<<< HEAD
		  if @token.save
			flash[:notice] = "Successfully linked profile to #{params[:provider]}."
		  else
		  
			flash[:alert] = "Encountered a problem saving your token for #{params[:provider]} to our database. Seek help!"
		  end
		  redirect_to "/oauth"
=======
      if @token.save
        flash[:notice] = "Successfully linked profile to #{params[:provider]}."
      end
      flash[:alert] = "Encountered a problem saving your token for #{params[:provider]} to our database. Seek help!"
    end
    redirect_to "/oauth"
>>>>>>> 2a515dbf1a1eeb639777b1b839912e31ca30eba8
			
    #rescue => e
    #flash[:alert] = "Sorry! We encountered an error getting data from #{params[:provider]}. If this continues. Please contact an admin."
    #redirect_to(:controller => "oauth_tokens", :action =>"index")
    #logger.info 'ERROR on create in oauth tokens'
    #logger.info e.message
    #end
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
