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
    session[:state] = rand(9999)
    redirect_to(@provider.getOAuthTokenRequestURL(session[:state]))
  end
  
  
  # POST /oauth_tokens
  def create
    begin
      #TODO:need code for validating the state!!!
      @user = User.find(session[:userid])
      @provider = getProviderClass(params[:provider])
    
      @code = params[:code]
      @state = params[:state]
      
      #Verify that the state is okay
      if (@provider != FourSquareProvider.service_name)
        if(@state != session[:state])
          raise "Problem verifying state"
        else
          session[:state] = nil
        end
      end
      @exchangeURL = @provider.getOAuthExchangeTokenURL(@code)
      client = HTTPClient.new
      
      if params[:provider] == "Google"
        @tokenResponse = client.post(@provider.exchange_url, @provider.getOAuthExchangeParams(@code))
      else
        @tokenResponse = client.get(@exchangeURL)
      end
      
      @token = @user.oauth_tokens.build({:provider => @tokenHash[:provider], :access_token => @tokenHash[:access_token], :expires_in =>  @tokenHash[:expires_in], :refresh_token =>  @tokenHash[:refresh_token]})
										  
      if @token.save
        flash[:notice] = "Successfully linked profile to #{params[:provider]}."
      else
        flash[:alert] = "Encountered a problem saving your token for #{params[:provider]} to our database. Seek help!"
      end
      
      redirect_to("/oauth")
			
    rescue => e
      flash[:alert] = "Sorry! We encountered an error getting data from #{params[:provider]}. If this continues. Please contact an admin."
      redirect_to("/oauth")
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
