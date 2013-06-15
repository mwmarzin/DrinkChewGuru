require 'FacebookProvider'
class OauthTokensController < ApplicationController
  # GET /oauth_tokens
  # GET /oauth_tokens.json
  
  def index
    @fb = FacebookProvider.new
    @oauth_tokens = OauthToken.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @oauth_tokens }
    end
  end

  # GET /oauth_tokens/1
  # GET /oauth_tokens/1.json
  def show
    @oauth_token = OauthToken.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @oauth_token }
    end
  end

  # GET /oauth_tokens/new
  # GET /oauth_tokens/new.json
  def new
    @oauth_token = OauthToken.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @oauth_token }
    end
  end

  # GET /oauth_tokens/1/edit
  def edit
    @oauth_token = OauthToken.find(params[:id])
  end

  # POST /oauth_tokens
  # POST /oauth_tokens.json
  def create
    @oauth_token = OauthToken.new(params[:oauth_token])

    respond_to do |format|
      if @oauth_token.save
        format.html { redirect_to @oauth_token, :notice => 'Oauth token was successfully created.' }
        format.json { render :json => @oauth_token, :status => :created, :location => @oauth_token }
      else
        format.html { render :action => "new" }
        format.json { render :json => @oauth_token.errors, :status => :unprocessable_entity }
      end
    end
  end

end
