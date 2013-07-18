class ModifyEvents < ActiveRecord::Migration
  def up
    remove_column :events, :created_by
    add_column :events, :description, :text
  end

  def down
    add_column :events, :created_by, :integer
    remove_column :events, :description
  end
end
