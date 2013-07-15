require 'FacebookProvider'
require 'FourSquareProvider'
require 'GoogleProvider'
class UsersController < ApplicationController
  before_filter :checklogin, :only =>[:profile]

  def login
    if session[:userid]
      redirect_to "/profile"
    else
      respond_to do |format|
        format.html # login.html.erb
      end
    end
  end

  def create
  		@mode = params[:'openid.mode']
		if(@mode == "cancel")
			flash[:alert] = "error"
			redirect_to "/"
    else
  		@fname = params[:'openid.ext1.value.firstname']
  		@lname = params[:'openid.ext1.value.lastname']
  		@email = params[:'openid.ext1.value.email']
  		@identity_url = params[:'openid.identity']
  #		@findUser = User.find_by_email(@email)
  		@user = User.find_by_email(@email)
  #		@message
  		if @user.nil?
  			@user = User.create(:first_name => @fname, :last_name => @lname, :email => @email, :identity_url => @identity_url)
              if @user.save
  				flash[:notice] = "User Created Successfully"
              else
  				flash[:alert] = "There was a problem!"
  		    end
  		else
  			flash[:notice] = "Logged in Successfully"
  		end
  		session[:userid] = @user.id
  #		session[:userid] = @user.email
  		redirect_to "/oauth"
    end
  end
  def signout
    if session[:userid]
      session[:userid] = nil
    end
    
    puts root_url
    redirect_to "/" , :notice => "You've been successfully logged out. Please comeback soon..."
  end

  def profile
    @todos = @user.getTodos(@tokensHash[FourSquareProvider.service_name].access_token)
  end
  
end
