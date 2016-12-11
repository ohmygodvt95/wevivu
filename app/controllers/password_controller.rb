class PasswordController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:update]

  def update
    if @user.update_attributes user_params
      render json: {status: 'success', data: {email: @user.email}}, status: :ok
    else
      render json: {status: 'success', data: {email: @user.email}}, status: 403
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  def set_user
    @user = User.find(params[:id])
  end
end
