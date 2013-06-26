class User < ActiveRecord::Base
  has_many :oauth_tokens
  attr_accessible :email, :first_name, :identity_url, :last_name
end
