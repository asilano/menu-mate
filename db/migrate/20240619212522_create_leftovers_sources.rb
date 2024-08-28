class CreateLeftoversSources < ActiveRecord::Migration[7.1]
  def change
    create_table :leftovers_sources do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :leftover, null: false, foreign_key: true
      t.integer :num_days

      t.timestamps
    end
  end
end
