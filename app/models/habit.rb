class Habit < ActiveRecord::Base
  validates :title, :category, :goal_type, :user_id, presence: true

  belongs_to :user

  ANSWERS = {
    "yes" => "positive",
    "start" => "positive",
    "no" => "negative",
    "stop" => "negative"
  }

  def make_current!
    current = self.user.habits.find_by(active: true)

    current.update_attribute(:active, false) if current.present?
    self.update_attributes(active: true, status: "ongoing")
  end

  def mark(response, date)
    if ANSWERS[response] == ANSWERS[goal_type]
      self.last_date = Date.parse(date)
    end
    
    self.save
  end
end
