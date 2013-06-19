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
  end

  # POST /oauth_tokens
  # POST /oauth_tokens.json
  def create

    respond_to do |format|
      format.html # create.html.erb
    end
  end

end
