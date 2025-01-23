class AddIndexToLeftoversOnNameAndUserId < ActiveRecord::Migration[7.2]
  def change
    add_index :leftovers, [:name, :user_id], unique: true
  end
end
