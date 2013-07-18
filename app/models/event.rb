class Event < ActiveRecord::Base
  attr_accessible :user_id, :name, :date_time, :email_invitees, :facebook_id, :facebook_invitees, :description, :google_id, :loacation_id
end
