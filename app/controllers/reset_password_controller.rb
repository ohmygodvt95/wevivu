class ResetPasswordController < ApplicationController
  skip_before_action :verify_authenticity_token
  def show
  end

  def create
    begin
      user = User.find_by_email params[:email]
    rescue ActiveRecord::RecordNotFound => e
      user = nil
    end
     if user.nil?
       flash[:mess] = "ERROR! Email not found!"
       redirect_to "/password"
     else
       user.update reset_token: SecureRandom.urlsafe_base64(32)
       ResetMail.send_reset_pass(user).deliver
       flash[:mess] = "SUCCESS! Please check email!"
       redirect_to "/password"
     end
  end

  def edit
    begin
      @user = User.find_by_reset_token params[:token]
    rescue ActiveRecord::RecordNotFound => e
      @user = nil
    end
    if @user.nil?
      redirect_to "/"
    else

    end
  end

  def success
    if !flash[:mess]
      redirect_to "/"
    end
  end

  def update
    begin
      @user = User.find_by_email params[:email]
    rescue ActiveRecord::RecordNotFound => e
      @user = nil
    end
    if @user.nil?
      redirect_to "/"
    else
      if @user.update password: params[:password], password_confirmation: params[:password_confirmation]
        @user.update reset_token: ''
        flash[:mess] = "Password was reset! login now"
        redirect_to "/password/success"
      else
        flash[:mess] = "Password invalid!"
        redirect_to "/password/edit/#{@user.reset_token}"
      end

    end
  end
end
