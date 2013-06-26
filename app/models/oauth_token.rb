class OauthToken < ActiveRecord::Base
  belongs_to :user
  attr_accessible :access_token, :expires_in, :provider_name, :refresh_token, :userid
end
