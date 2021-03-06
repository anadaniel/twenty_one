require 'rails_helper'

RSpec.describe Api::V1::HabitsController, :type => :controller do
  before do
    @user = FactoryGirl.create :user
    api_authorization_header( @user.auth_token )
  end

  describe "POST #create" do
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

  describe "GET #current" do
    context "when user has an active habit" do
      before do
        @current_habit = FactoryGirl.create :start_habit, user: @user, active: true

        get :current
      end

      it { should respond_with :ok }
      it { expect(json_response).to have_key(:habit) }
      it { expect(json_response[:habit][:id]).to eq(@current_habit.id) }
    end

    context "when user doesn't have an active habit" do
      before do
        not_current_habit = FactoryGirl.create :start_habit, user: @user, active: false

        get :current
      end

      it { should respond_with :no_content }
    end
  end

  describe "POST #mark" do
    context "when marking a start goal_type habit" do
      before do
        @start_habit = FactoryGirl.create :start_habit, user: @user, active: true
      end

      context "and the answer is yes" do
        before do
          post :mark, { id: @start_habit.id, response: "yes", date: "#{Date.today.strftime("%Y-%m-%d")}" }
          @start_habit.reload
        end

        it { should respond_with :ok }
        it { expect(@start_habit.status).to eq "ongoing" }
        it { expect(@start_habit.last_date).to eq Date.today }
      end

      context "and the answer is no" do
        before do
          post :mark, { id: @start_habit.id, response: "no", date: "#{Date.today.strftime("%Y-%m-%d")}" }
          @start_habit.reload
        end

        it { should respond_with :ok }
        it { expect(@start_habit.status).to eq "failed" }
        it { expect(@start_habit.last_date).to eq nil }
      end
    end

    context "when marking a stop goal_type habit" do
      before do
        @start_habit = FactoryGirl.create :stop_habit, user: @user, active: true
      end

      context "and the answer is no" do
        before do
          post :mark, { id: @start_habit.id, response: "no", date: "#{Date.today.strftime("%Y-%m-%d")}" }
          @start_habit.reload
        end

        it { should respond_with :ok }
        it { expect(@start_habit.status).to eq "ongoing" }
        it { expect(@start_habit.last_date).to eq Date.today }
      end

      context "and the answer is yes" do
        before do
          post :mark, { id: @start_habit.id, response: "yes", date: "#{Date.today.strftime("%Y-%m-%d")}" }
          @start_habit.reload
        end

        it { should respond_with :ok }
        it { expect(@start_habit.status).to eq "failed" }
        it { expect(@start_habit.last_date).to eq nil }
      end
    end

    context "when its the first mark of an habit" do
      before do
        @new_habit = FactoryGirl.create :start_habit, user: @user, active: true
        post :mark, { id: @new_habit.id, response: "yes", date: "#{Date.today.strftime("%Y-%m-%d")}" }
        @new_habit.reload
      end

      it { should respond_with :ok }
      it { expect(@new_habit.start_date).to eq Date.today }
    end
  end

  describe "POST #fail" do
    before do
      @habit = FactoryGirl.create :start_habit, user: @user, 
                                                      active: true, 
                                                      start_date: Date.yesterday,
                                                      last_date: Date.yesterday,
                                                      status: "ongoing"

      post :fail, { id: @habit.id }

      @habit.reload
    end

    it { should respond_with :ok }
    it { expect(@habit.status).to eq "failed" }
    it { expect(@habit.last_date).to eq nil }
    it { expect(@habit.start_date).to eq nil }
  end
end
