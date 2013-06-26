class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :identity_url, :last_name
end
