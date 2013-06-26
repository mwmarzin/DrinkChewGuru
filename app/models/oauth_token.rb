class OauthToken < ActiveRecord::Base
  attr_accessible :accress_token, :refresh_token, :secret_token, :service_name, :username
end
