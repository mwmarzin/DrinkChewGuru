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
	
	 # code for getting refresh token from Google in case if the access token expires

# def refreshtokens
# 	if @tokensHash = ["Google"]
#		if (Time.now-oauth_token.created_at) = 0	
#			@tokensHash = client.post(https://accounts.google.com/o/oauth2/token
#&client_id=307247955504.apps.googleusercontent.com
#&client_secret=W1kRezogoDm61Gmyp_gqgI7y
#&refresh_token=@tokenHash[:refresh_token]
#&grant_type=refresh_token)
#		else 
#		flash[:alert] = "Encountered a problem saving your token for Google to our database. Seek help!"
			
#				end
#		end
		
  end
end
