class FixEventsNames < ActiveRecord::Migration
  def up
    rename_column :events, :event_id, :user_id
  end

  def down
    rename_column :events, :user_id, :event_id
  end
end
