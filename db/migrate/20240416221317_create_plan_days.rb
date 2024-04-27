class CreatePlanDays < ActiveRecord::Migration[7.1]
  def change
    create_table :plan_days do |t|
      t.references :menu_plan, null: false, foreign_key: true
      t.integer :day_number
      t.references :recipe, null: true, foreign_key: true

      t.timestamps
    end
  end
end
