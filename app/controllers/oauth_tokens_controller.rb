require 'Provider'
require 'FacebookProvider'
require 'httpclient'
require 'json'
class OauthTokensController < ApplicationController

  def index
    @provider = FacebookProvider
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def call
    @provider = Provider.new
    if params[:provider] == "Facebook"
      redirect_to(FacebookProvider.getOAuthTokenRequestURL())
    elsif params[:provider] == "Google"
      #add this in later
    end

    #@responseArray = JSON.parse(@responseJSON.to_s)
    #respond_to do |format|
    #  format.html #request.html.erb
    #end
  end

  # POST /oauth_tokens
  # POST /oauth_tokens.json
  def create

    #need code for validating the state!!!
    #@provider = Provider.new
    #if params[:provider] == "Facebook"
    #  @provider = FacebookProvider.new(request.host)
    #elsif params[:provider] == "Google"
    #  #add this in later
    #end
    
    @code = params[:code]
    @state = params[:state]
    @exchangeURL = FacebookProvider.getOAuthExchangeTokenURL(@code)
    client = HTTPClient.new
    @response = client.get(@exchangeURL)
    @token = FacebookProvider.validateOAuthToken(@response.body)
    headers={"access_token"=>@token}
    @response = client.get("https://graph.facebook.com/me/friends?fields=first_name,picture&limit=5",headers)
    @responseJSON = JSON.parse(@response.body)
    respond_to do |format|
      format.html # create.html.erb
    end
  end

end
