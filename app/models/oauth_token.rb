class OauthToken < ActiveRecord::Base
  belongs_to :user
  attr_accessible :access_token, :refresh_token, :provider, :user_id, :expires_in
end
