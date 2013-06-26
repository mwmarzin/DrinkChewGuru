class OauthToken < ActiveRecord::Base
  attr_accessible :access_token, :refresh_token, :provider, :userid, :expires_in
end
