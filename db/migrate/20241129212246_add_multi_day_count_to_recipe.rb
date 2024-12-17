class AddMultiDayCountToRecipe < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :multi_day_count, :integer, default: 1
  end
end
