class AddProviderToOauthToken < ActiveRecord::Migration
  def change
    add_column :oauth_tokens, :provider, :string
  end
end
