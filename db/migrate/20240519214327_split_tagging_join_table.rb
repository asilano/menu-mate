class SplitTaggingJoinTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :taggings do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, null: false, polymorphic: true

      t.timestamps
    end

    create_table :recipe_properties do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    create_table :plan_day_restrictions do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :plan_day, null: false, foreign_key: true

      t.timestamps
    end
  end
end
