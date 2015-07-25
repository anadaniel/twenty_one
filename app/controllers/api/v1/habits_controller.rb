class Api::V1::HabitsController < ApplicationController
  before_action :authenticate_with_token!, only: [:destroy]

  def create
    habit = current_user.habits.build habits_params

    if habit.save
      habit.make_current!
      head :created
    else
      head :unprocessable_entity
    end
  end

  private
    def habits_params
      params.require(:habit).permit(:title, :goal_type, :category, :partner_name, :partner_email)
    end
end
