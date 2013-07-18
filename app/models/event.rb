#this is the event model, used for storing events in our database
class Event < ActiveRecord::Base
    belongs_to :user
  attr_accessible :user_id, :name, :date_time, :email_invitees, :facebook_id, :facebook_invitees, :description, :google_id, :loacation_id
end
