class AddColourToLeftovers < ActiveRecord::Migration[7.2]
  def change
    add_column :leftovers, :colour, :string, limit: 7, default: "#000000"
  end
end
