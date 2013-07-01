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
    #@responseArray = JSON.parse(@responseJSON.to_s)
    #respond_to do |format|
    #  format.html #request.html.erb
    #end
  end

  # POST /oauth_tokens
  # POST /oauth_tokens.json
  def create

    #TODO:need code for validating the state!!!
    @provider = getProviderClass(params[:provider])
    
    @code = params[:code]
    @state = params[:state]
    
    @exchangeURL = @provider.getOAuthExchangeTokenURL(@code)
    client = HTTPClient.new
    @tokenResponse = client.get(@exchangeURL)
    @tokenHash = @provider.returnToken(@tokenResponse)
    
    #The next couple lines are just to test getting data with the tokens we've just retrieved from the provider
    if params[:provider] == "Facebook"  
      headers={"access_token"=>@tokenHash[:access_token]}
      @response = client.get("https://graph.facebook.com/me/friends?fields=first_name,picture&limit=5",headers)
    elsif providerName == "Google"
<<<<<<< HEAD

=======
      headers={"Authorization: Bearer "=>@tokenHash[:access_token]}
      @response = client.get("https://www.googleapis.com/oauth2/v1/userinfo?access_token=1/fFBGRNJru1FQd44AzqT3Zg",headers)
>>>>>>> ce1dcf83764b05f524b744c6b3169ea0459049d8
    elsif providerName == "FourSquare"
      #add in some sort of a test call to the FourSquare API
    else
      raise "WHOA! I don't know who this is!"
    end

    @responseJSON = JSON.parse(@response.body)
    
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