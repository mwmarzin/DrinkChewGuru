class User < ActiveRecord::Base
  has_many :oauthtokens
  attr_accessible :email, :first_name, :identity_url, :last_name
end
