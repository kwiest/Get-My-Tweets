class AddRemoteUriToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :remote_uri, :string
  end
end
