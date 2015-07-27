class Habit < ActiveRecord::Base
  validates :title, :category, :goal_type, :user_id, presence: true

  belongs_to :user

  before_save :set_start_date, if: Proc.new { |habit| habit.start_date.nil? and habit.last_date.present? }
  after_save :check_if_completed, if: Proc.new { |habit| habit.start_date.present? and habit.last_date.present? }

  ANSWERS = {
    "yes" => "positive",
    "start" => "positive",
    "no" => "negative",
    "stop" => "negative"
  }

  def set_start_date
    self.start_date = self.last_date
  end

  def check_if_completed
    self.update_column(:status, "completed") if successful_days >= 21
  end

  def make_current!
    current = self.user.habits.find_by(active: true)

    current.update_attribute(:active, false) if current.present?
    self.update_attributes(active: true, status: "ongoing")
  end

  def mark(response, date)
    if ANSWERS[response] == ANSWERS[goal_type]
      self.mark_success(date)
    else
      self.fail_habit
    end
  end

  def mark_success(date)
    self.last_date = Date.parse(date)
    self.status = "ongoing"

    self.save
  end

  def fail_habit
    self.last_date = nil
    self.start_date = nil
    self.status = "failed"

    self.save
  end

  def successful_days
    return 0 if self.start_date.nil?

    (self.last_date - self.start_date).to_i + 1
  end
end
