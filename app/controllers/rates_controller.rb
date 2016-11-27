class RatesController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    rate = Rate.new(rate_params)
    post = Post.find params[:rate][:post_id]
    post.data["rates"][params[:rate][:point]] = post.data["rates"][params[:rate][:point]] + 1
    if rate.save && post.save
      render json: {status: 'success', data: {rate: rate, rates: post.data["rates"]}}, status: :ok
    else
      render json:{status: 'failure', data: rate.errors}, status: :unprocessable_entity
    end

  end

  def update
    rate = Rate.find_by(post_id: params[:rate][:post_id], user_id:  params[:rate][:user_id])
    post = Post.find params[:rate][:post_id]
    post.data["rates"][rate.point] = post.data["rates"][rate.point] - 1
    post.data["rates"][params[:rate][:point]] = post.data["rates"][params[:rate][:point]] + 1
    rate.point = params[:rate][:point]
    if rate.save && post.save
      render json: {status: 'success', data: {rate: rate, rates: post.data["rates"]}}, status: :ok
    else
      render json:{status: 'failure', data: rate.errors}, status: :unprocessable_entity
    end
  end

  def destroy
    rate = Rate.find params[:id]
    post = Post.find rate.post_id
    post.data["rates"][rate.point] = post.data["rates"][rate.point] - 1
    if rate.destroy && post.save
      render json: {status: 'success', data: {rate: rate, rates: post.data["rates"]}} , status: :ok
    else
      render json:{status: 'failure', data: rate.errors}, status:  404
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