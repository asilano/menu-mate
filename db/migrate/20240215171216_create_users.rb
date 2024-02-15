class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :google_userid, null: false
      t.string :email, null: false
      t.string :name
      t.string :first_name
      t.string :picture_uri

      t.timestamps
    end

    add_index :users, :google_userid, unique: true
  end
end
