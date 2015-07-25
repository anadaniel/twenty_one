class Habit < ActiveRecord::Base
  validates :title, :category, :goal_type, :user_id, presence: true

  belongs_to :user

  def make_current!
    current = self.user.habits.find_by(active: true)

    current.update_attribute(:active, false) if current.present?
    self.update_attribute(:active, true)
  end
end
