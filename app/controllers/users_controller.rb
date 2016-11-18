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
      render json: {status: "success", data: {email: @user}}, status: 200
    end
  end
  # POST create one user
  def create

    @user = User.new(user_params)
    @user.avatar = "https://viblo.asia/img/categories/320/ruby.png"
    @user.cover = "https://viblo.asia/img/categories/320/ruby.png"

    respond_to do |format|

      if @user.save
        #format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: {status: 'success', data: {email: @user.email}}, status: :ok}
      else
        #format.html { render :new }
        format.json { render json:{status: 'failure', data: @user.errors}, status: :unprocessable_entity }
      end
    end
  end


  # PATCH update a user

  def update

    @user = User.find(params[:id])
    @new_update = User.new(user_update_params)
    @user.name = @new_update.name
    @user.date_of_birth = @new_update.date_of_birth
    @user.sex = @new_update.sex
    @user.avatar = @new_update.avatar
    @user.cover = @new_update.cover

    if @user.save
      #format.html { redirect_to @user, notice: 'User was successfully created.' }
        render json: {status: 'success', data: {email: @user.email}}, status: 200
    else
      #format.html { render :new }
        render json:{status: 'failure', data: @user.errors}, status: 400
    end
  end


  private
      def user_params
    params.require(:user).permit(:email, :password, :name, :password_confirmation, :date_of_birth, :sex)
  end

  private
      def user_update_params
        params.require(:user).permit(  :name,  :date_of_birth, :sex, :avatar, :cover)
      end




end