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
    @provider = getProviderClass(params[:provider])

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
    @provider = getProviderClass(params[:provider])
    
    @code = params[:code]
    @state = params[:state]
    @exchangeURL = FacebookProvider.getOAuthExchangeTokenURL(@code)
    client = HTTPClient.new
    @response = client.get(@exchangeURL)
    @token = FacebookProvider.returnToken(@response.body)
    headers={"access_token"=>@token}
    @response = client.get("https://graph.facebook.com/me/friends?fields=first_name,picture&limit=5",headers)
    @responseJSON = JSON.parse(@response.body)
    
    OauthToken.create({:provider => @token.provider,  :access_token => @token.access_token,
                       :userid => @token.userid, :expires_in => @token.expires_in, :refresh_token => @token.refresh_token})
    
    
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