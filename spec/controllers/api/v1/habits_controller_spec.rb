require 'rails_helper'

RSpec.describe Api::V1::HabitsController, :type => :controller do
  describe "POST #create" do
    before do
      user = FactoryGirl.create :user
      api_authorization_header( user.auth_token )
    end
    context "with valid attributes" do
      before do
        @habit = FactoryGirl.build :start_habit

        post :create, { habit: { 
                          title: @habit.title, goal_type: @habit.goal_type, category: @habit.category, 
                          partner_name: @habit.partner_name, partner_email: @habit.partner_email 
                        } 
                      }
      end

      it { should respond_with :created }
    end

    context "with invalid attributes" do
      before do
        @habit = FactoryGirl.build :start_habit
        post :create, { habit: { 
                          title: nil, goal_type: @habit.goal_type, category: @habit.category, 
                          partner_name: @habit.partner_name, partner_email: @habit.partner_email 
                        } 
                      }
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end
