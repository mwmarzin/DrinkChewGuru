class CreateOauthTokens < ActiveRecord::Migration
  def change
    create_table :oauth_tokens do |t|
      t.integer :userid
      t.string :provider_name
      t.string :access_token
      t.string :refresh_token
      t.integer :expires_in

      t.timestamps
    end
  end
end
