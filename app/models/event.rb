class Event < ActiveRecord::Base
  attr_accessible :created_by, :date_time, :email_invitees, :event_id, :facebook_id, :facebook_invitees, :google_id, :loacation_id
end
