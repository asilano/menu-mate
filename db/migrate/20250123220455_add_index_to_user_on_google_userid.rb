class AddIndexToUserOnGoogleUserid < ActiveRecord::Migration[7.2]
  def change
    remove_index :users, :google_userid
    add_index :users, :google_userid, unique: true
  end
end
