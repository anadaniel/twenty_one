require 'rails_helper'

RSpec.describe Habit, :type => :model do
  let(:habit) { FactoryGirl.create :start_habit }

  subject { habit }

  context "attributes" do
    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:partner_name) }
    it { is_expected.to respond_to(:partner_email) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:start_date) }
    it { is_expected.to respond_to(:last_date) }
    it { is_expected.to respond_to(:active) }
    it { is_expected.to respond_to(:goal_type) }
  end
end
