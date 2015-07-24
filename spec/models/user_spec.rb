require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.create :user }

  subject { user }

  context "attributes" do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:auth_token) }
  end

  context "validations" do
    it { is_expected.to validate_uniqueness_of(:auth_token) }
  end

  context "#methods" do
    describe "#generate_authentication_token!" do
      before { @user = FactoryGirl.create :user }
      
      it "generates a unique token" do
        Devise.stub(:friendly_token).and_return("auniquetoken123")
        @user.generate_authentication_token!
        expect(@user.auth_token).to eql "auniquetoken123"
      end

      it "generates another token when one already has been taken" do
        existing_user = FactoryGirl.create(:user, auth_token: "auniquetoken123")
        @user.generate_authentication_token!
        expect(@user.auth_token).not_to eql existing_user.auth_token
      end
    end
  end
end
