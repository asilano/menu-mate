class AddLastAutoStartDayToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_auto_start_day, :string
  end
end
