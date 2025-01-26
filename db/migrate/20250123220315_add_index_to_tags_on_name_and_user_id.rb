class AddIndexToTagsOnNameAndUserId < ActiveRecord::Migration[7.2]
  def change
    add_index :tags, [:name, :user_id], unique: true
  end
end
