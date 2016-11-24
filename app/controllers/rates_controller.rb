class RatesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create

    @rate = Rate.new(rate_params)
    if @rate.save
      render json: {status: 'success', data: {point: @rate.point}}, status: :ok
    else
      render json:{status: 'failure', data: @rate.errors}, status: :unprocessable_entity
    end

  end

  def destroy
    @rate =Rate.new(rate_destroy_params)
    @rate_destroy = Rate.find_by(user_id: @rate.user_id, post_id: @rate.post_id)
    if @rate_destroy.destroy
      render json: {status: 'success'} , status: :ok
    else
      render json:{status: 'failure', data: @rate.errors}, status:  404
    end

  end

  private
  def rate_params
    params.require(:rate).permit(:user_id, :post_id, :point)
  end

  def rate_destroy_params
    params.require(:rate).permit(:user_id, :post_id)
  end

end