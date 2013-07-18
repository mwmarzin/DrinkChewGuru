# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130718071242) do

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "loacation_id"
    t.datetime "date_time"
    t.integer  "facebook_id"
    t.integer  "google_id"
    t.text     "email_invitees"
    t.text     "facebook_invitees"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "description"
    t.string   "name"
  end

  create_table "oauth_tokens", :force => true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "provider"
    t.integer  "user_id"
    t.integer  "expires_in"
  end

  create_table "users", :force => true do |t|
    t.string   "identity_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
