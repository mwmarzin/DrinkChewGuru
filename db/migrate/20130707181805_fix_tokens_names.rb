class FixTokensNames < ActiveRecord::Migration
  def up
    rename_column :oauth_tokens, :userid, :user_id
  end

  def down
    rename_column :oauth_tokens, :user_id, :userid
  end
end
