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

<<<<<<< HEAD
<<<<<<< HEAD
ActiveRecord::Schema.define(:version => 20130625175856) do
=======
ActiveRecord::Schema.define(:version => 20130625024616) do
>>>>>>> fc799565f6e42f8b116ba73a4d185003743ba01e
=======
ActiveRecord::Schema.define(:version => 20130625024616) do
>>>>>>> fc799565f6e42f8b116ba73a4d185003743ba01e

  create_table "oauth_tokens", :force => true do |t|
    t.string   "username"
    t.string   "service_name"
    t.string   "accress_token"
    t.string   "secret_token"
    t.string   "refresh_token"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "provider"
  end

<<<<<<< HEAD
<<<<<<< HEAD
  create_table "oauths", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

=======
>>>>>>> fc799565f6e42f8b116ba73a4d185003743ba01e
=======
>>>>>>> fc799565f6e42f8b116ba73a4d185003743ba01e
  create_table "users", :force => true do |t|
    t.string   "identity_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
