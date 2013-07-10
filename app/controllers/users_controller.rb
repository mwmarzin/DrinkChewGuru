class UsersController < ApplicationController
  before_filter :checklogin, :only =>[:profile]

  def login
    @user = User.new
    respond_to do |format|
      format.html # login.html.erb
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      session[:userid] = @user.id
      redirect_to "/oauth", :notice => "Account Created!"
    else
      render "login"
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
    
  end
end
