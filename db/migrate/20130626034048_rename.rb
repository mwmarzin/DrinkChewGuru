class Rename < ActiveRecord::Migration
  def change
    rename_column :oauth_tokens, :accress_token, :access_token
  end
end
