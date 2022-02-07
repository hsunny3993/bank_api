class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def_param_group :auth do
    param :email, String, required: true, desc: 'user email'
    param :password, String, required: true, desc: 'user password'
  end

  api :POST, '/authenticate', 'Authenticate user credentials and returns jwt token'
  param_group :auth
  def auth
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
      render json: { auth_token: command.result }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
