class Habit < ActiveRecord::Base
  validates :title, :category, :goal_type, :user_id, presence: true

  belongs_to :user
end
