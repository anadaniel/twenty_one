require 'rails_helper'

RSpec.describe Api::V1::SessionsController, :type => :controller do
  describe "POST #create" do
    context "when the user does not exists" do
      context "and his information is valid" do
        before do
          @new_user = FactoryGirl.build :user
          post :create, { email: @new_user.email, password: @new_user.password  }
        end

        it { should respond_with 200 }
        it { expect(json_response).to have_key(:auth_token) }

        it "creates a user and returns the auth token for that user" do
          created_user = User.find_by email: @new_user.email
          expect(json_response[:auth_token]).to eql created_user.auth_token
        end
      end

      context "and his information is invalid" do
        before do
          post :create, { email: "invalid email", password: "123456"  }
        end

        it { should respond_with 422 }
        it { expect(json_response).to have_key(:errors) }
      end

      context "and his information is incomplete" do
        before do
          @new_user = FactoryGirl.build :user
          post :create, { email: @new_user.email } #no password
        end

        it { should respond_with 422 }
        it { expect(json_response).to have_key(:errors) }
      end
    end

    context "when the user already exists" do
      context "and his credentials are correct" do
        before do
          @existing_user = FactoryGirl.create :user
          post :create, { email: @existing_user.email, password: @existing_user.password  }
        end

        it { should respond_with 200 }
        it { expect(json_response).to have_key(:auth_token) }

        it "returns the auth token for the existing user" do
          @existing_user.reload
          expect(json_response[:auth_token]).to eql @existing_user.auth_token
        end
      end

      context "and his credentials are incorrect" do
        before do
          @existing_user = FactoryGirl.create :user
          post :create, { email: @existing_user.email, password: "wrongpassword"  }
        end

        it { should respond_with 422 }
        it { expect(json_response).to have_key(:errors) }
      end
    end
  end
end
