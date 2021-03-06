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

  def mark
    habit = current_user.habits.find params[:id]

    unless params[:response].nil? || params[:date].nil? || habit.nil?
      habit.mark(params[:response], params[:date])

      head :ok
    else
      head :unprocessable_entity
    end
  end

  def fail
    habit = current_user.habits.find params[:id]

    if habit.present?
      habit.fail_habit
      head :ok
    else
      head :unprocessable_entity
    end    
  end

  private
    def habits_params
      params.require(:habit).permit(:title, :goal_type, :category, :partner_name, :partner_email)
    end
end
