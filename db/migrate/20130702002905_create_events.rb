class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.integer :loacation_id
      t.datetime :date_time
      t.integer :facebook_id
      t.integer :google_id
      t.text :email_invitees
      t.text :facebook_invitees
      t.integer :created_by

      t.timestamps
    end
  end
end
