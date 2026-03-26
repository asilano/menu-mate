class AddRestrictiveToTags < ActiveRecord::Migration[8.0]
  def change
    add_column :tags, :restrictive, :boolean, default: false
  end
end
