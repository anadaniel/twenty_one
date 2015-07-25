class AddStatusToHabits < ActiveRecord::Migration
  def change
    add_column :habits, :status, :string, default: ""
  end
end
