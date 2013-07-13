class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def checklogin
    if !session[:userid]
      flash[:alert] = "Please sign in."
      redirect_to("/")
    else
      @user = User.find_by_email(session[:userid])
      @tokensHash = @user.oauth_tokens.index_by(&:provider)
      
      #TODO could check in here if the users tokens are still valid, if they aren't call another method to refresh the token
      #if the refresh fails, redirect to "/oauth"
    end
  end
end
