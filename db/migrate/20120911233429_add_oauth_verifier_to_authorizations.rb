class AddOauthVerifierToAuthorizations < ActiveRecord::Migration
  def change
    change_table :authorizations do |t|
      t.rename :oauth_token_secret, :oauth_verifier
    end
  end
end
