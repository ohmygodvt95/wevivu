class AvatarController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    user = User.find current_user.id
    if user.update avatar: params[:file]
      render json: {status: "success", data: user}, status: 200
    else
      render json: {status: "failure", data: user}, status: 501
    end

  end
end