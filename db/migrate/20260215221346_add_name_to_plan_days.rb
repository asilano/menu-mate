class AddNameToPlanDays < ActiveRecord::Migration[8.0]
  def change
    add_column :plan_days, :name, :string, null: true
  end
end
