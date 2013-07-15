class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def checklogin
    if !session[:userid]
      flash[:alert] = "Please sign in."
      redirect_to("/")
    else
      @user = User.find(session[:userid])
      @tokensHash = @user.oauth_tokens.index_by(&:provider)
      
      @user.oauth_tokens.each do |token|
        
      end
      #TODO could check in here if the users tokens are still valid, if they aren't call another method to refresh the token
      #if the refresh fails, redirect to "/oauth"
    end
  end
end
