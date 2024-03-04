class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end

    add_index :recipes, :name, unique: false
  end
end
