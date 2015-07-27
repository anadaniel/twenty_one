require 'rails_helper'

RSpec.describe Habit, :type => :model do
  let(:habit) { FactoryGirl.create :start_habit }

  subject { habit }

  context 'attributes' do
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:partner_name) }
    it { is_expected.to respond_to(:partner_email) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:start_date) }
    it { is_expected.to respond_to(:last_date) }
    it { is_expected.to respond_to(:active) }
    it { is_expected.to respond_to(:goal_type) }
    it { is_expected.to respond_to(:user_id) }
    it { is_expected.to respond_to(:status) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:goal_type) }
    it { is_expected.to validate_presence_of(:user_id) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  context 'instance methods' do
    describe '#make_current!' do
      before do
        user = FactoryGirl.create :user
        @old_current = FactoryGirl.create :start_habit, active: true, user: user
        @new_current = FactoryGirl.create :start_habit, active: false, user: user

        @new_current.make_current!

        @old_current.reload
        @new_current.reload
      end

      it { expect(@new_current.active).to be true }
      it { expect(@new_current.status).to eq "ongoing" }
      it { expect(@old_current.active).to be false }
    end
  end

  context 'callbacks' do
    describe '#check_if_completed' do
      before { @habit = FactoryGirl.create :start_habit, status: 'ongoing' }
      
      context 'when 21 days have passed' do
        before do
          @habit.start_date = 20.days.ago.to_date
          @habit.last_date = Date.today

          @habit.save
        end

        it "sets the status to 'completed'" do
          expect(@habit.status).to eq 'completed'
        end
      end

      context 'when 21 days have not passed' do
        before do
          @habit.start_date = 19.days.ago.to_date
          @habit.last_date = Date.today

          @habit.save
        end

        it "leaves the status as ongoing" do
          expect(@habit.status).to eq 'ongoing'
        end
      end
    end
  end
end
