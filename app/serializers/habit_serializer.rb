class HabitSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :goal_type, :partner_name, :partner_email, :status, :successful_days
end
