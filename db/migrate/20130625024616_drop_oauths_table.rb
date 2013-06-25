class DropOauthsTable < ActiveRecord::Migration
  def up
    drop_table :oauths
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end