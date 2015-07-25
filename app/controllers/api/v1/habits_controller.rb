class Api::V1::HabitsController < ApplicationController
  before_action :authenticate_with_token!

  def create
    habit = current_user.habits.build habits_params

    if habit.save
      habit.make_current!
      head :created
    else
      head :unprocessable_entity
    end
  end

  def current
    habit = current_user.habits.find_by active: true

    if habit.present?
      render json: habit, status: :ok
    else
      head :no_content
    end    
  end

  private
    def habits_params
      params.require(:habit).permit(:title, :goal_type, :category, :partner_name, :partner_email)
    end
end
