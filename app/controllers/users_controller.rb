class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /users/1.json
  def show
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @user = nil
    end

    if @user.nil?
      render json:{status: "failure", data: @user}, status: 404
    else
      render json: {status: "success", data: @user}, status: 200
    end
  end
  # POST create one user
  def create

    @user = User.new(user_params)

      if @user.save
        UserEmail.send_signup_email(@user).deliver
        #format.html { redirect_to @user, notice: 'User was successfully created.' }
        render json: {status: 'success', data: {email: @user.email}}, status: :ok
      else
        #format.html { render :new }
         render json:{status: 'failure', data: @user.errors}, status: :unprocessable_entity
      end
    end


  # PATCH update a user

  def update
    user = User.find(params[:user][:id])
    if user.update_attributes(name: params[:user][:name], date_of_birth: params[:user][:date_of_birth].first(10), status: params[:user][:status], sex: params[:user][:sex])
        render json: {status: 'success', data: user}, status: 200
    else
        render json:{status: 'failure', data: user.errors}, status: 400
    end
  end


  private
  def user_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation)
  end

  private
      def user_update_params
        params.require(:user).permit(  :name,  :date_of_birth, :sex)
      end

end




