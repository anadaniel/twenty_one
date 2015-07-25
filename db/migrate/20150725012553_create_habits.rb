class CreateHabits < ActiveRecord::Migration
  def change
    create_table :habits do |t|
      t.string :title
      t.string :goal_type
      t.string :category
      t.string :partner_name, default: ""
      t.string :partner_email, default: ""
      t.date :start_date
      t.date :last_date
      t.boolean :active

      t.timestamps null: false
    end
  end
end
