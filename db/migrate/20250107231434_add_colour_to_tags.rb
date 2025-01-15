class AddColourToTags < ActiveRecord::Migration[7.2]
  def change
    add_column :tags, :colour, :string, limit: 7, default: "#000000"
  end
end
