class CreateOauthTokens < ActiveRecord::Migration
  def change
    create_table :oauth_tokens do |t|
      t.string :username
      t.string :service_name
      t.string :accress_token
      t.string :secret_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
