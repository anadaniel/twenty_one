class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_or_initialize_by email: params[:email]

    if user.new_record?
      user.password, user.password_confirmation = params[:password], params[:password]

      unless user.save
        render json: { errors: "Your account could not be created" }, status: 422 and return
      end
    else
      if user.valid_password? params[:password]
        user.generate_authentication_token!
        user.save
      else
        render json: { errors: "Invalid credentials" }, status: 422 and return
      end
    end

    render json: { user_id: user.id, auth_token: user.auth_token }, status: 200
  end
end
