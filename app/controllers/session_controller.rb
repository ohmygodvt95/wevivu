class SessionController < ApplicationController
  skip_before_action :verify_authenticity_token
  # POST check anf create session
  def create
    user = User.find_by(email: params[:user][:email].downcase)
    if user && user.authenticate(params[:user][:password])
      log_in user
      render json: {status: 'success', data: {email: user.email}}, status: :ok
    else
      render json: {status: 'failure', data: {error: 'Invalid email/password combination'}}, status: :ok
    end
  end
  # DELETE delete session
  def destroy
    if logged_in?
      logout
      render json: {status: 'success'}, status: :ok
    else
      render json: {status: 'failure'}, status: :ok
    end
  end
end
