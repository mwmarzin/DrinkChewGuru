class ChangeOauthToken < ActiveRecord::Migration
  def change
    remove_column :oauth_tokens, :username, :string
    remove_column :oauth_tokens, :service_name, :string
    remove_column :oauth_tokens, :secret_token, :string
    add_column :oauth_tokens, :userid, :integer
    add_column :oauth_tokens, :expires_in, :integer
  end
end
