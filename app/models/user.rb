class User < ActiveRecord::Base
  has_many :oauth_tokens, :dependent => :destroy
  has_many :events, :dependent => :destroy
  attr_accessible :email, :first_name, :identity_url, :last_name
  accepts_nested_attributes_for :oauth_tokens, :events
end
