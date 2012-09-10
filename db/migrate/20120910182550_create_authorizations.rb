class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :user_id
      t.string :username
      t.string :oauth_token
      t.string :oauth_token_secret
      t.boolean :authorized, default: false

      t.timestamps
    end
  end
end
