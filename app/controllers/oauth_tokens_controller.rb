require 'Provider'
require 'FacebookProvider'
require 'httpclient'
require 'json'
class OauthTokensController < ApplicationController

  def index
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def call
    @provider = Provider.new
    if params[:provider] == "Facebook"
      @provider = FacebookProvider.new
    elsif params[:provider] == "Google"
      #add this in later
    end

    redirect_to(@provider.getOAuthTokenRequestURL())
    #@responseArray = JSON.parse(@responseJSON.to_s)
    #respond_to do |format|
    #  format.html #request.html.erb
    #end
  end

  # POST /oauth_tokens
  # POST /oauth_tokens.json
  def create

    #need code for validating the state!!!
    @provider = Provider.new
    if params[:provider] == "Facebook"
      @provider = FacebookProvider.new
    elsif params[:provider] == "Google"
      #add this in later
    end
    
    @code = params[:code]
    @state = params[:state]
    @exchangeURL = @provider.getOAuthExchangeTokenURL(@code)
    client = HTTPClient.new
    @response = client.get(@exchangeURL)
    @token = @provider.validateOAuthToken(@response.body)

    respond_to do |format|
      format.html # create.html.erb
    end
  end

end
