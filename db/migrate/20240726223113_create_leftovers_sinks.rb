class CreateLeftoversSinks < ActiveRecord::Migration[7.1]
  def change
    create_table :leftovers_sinks do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :leftover, null: false, foreign_key: true

      t.timestamps
    end
  end
end
