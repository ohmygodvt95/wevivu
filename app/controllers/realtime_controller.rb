class RealtimeController < ApplicationController
  skip_before_action :verify_authenticity_token
  MAX = 99999999999999999999
  def show
    posts = Post.where("id > ? AND user_id != ?", Integer(params[:before]), current_user.id).count
    if posts > 0
      render json: {status: 'success', data: posts}, status: :ok
    else
      render json: {status: 'failure', data: posts}, status: :ok
    end
  end

  def show_comments
    comments = Comment.where("id > ? and post_id = ?", Integer(params[:before]), Integer(params[:post_id])).order(id: :asc).limit Integer(params[:limit])
    render json: {
        status: 'success',
        data: comments.as_json(
            include: [
                {
                    user:
                        {
                            only: [:id, :name, :avatar]
                        }
                }]),
        total: comments.count,
        before: comments.count == 0 ? 0 : comments.last.id
    }, status: :ok
  end

  def new_posts
    posts = Post.where("id > ? AND user_id != ?", Integer(params[:before]), current_user.id).order("id desc")
    render json: {
        status: 'success',
        data: posts.as_json(
            include: [
                {
                    user:
                        {
                            only: [:id, :name, :avatar]
                        }
                },
                :location,
                {
                    images: {
                        only: [:id, :src]
                    }
                },
                :rates]),
        total: posts.count,
        before: posts.count > 0 ? posts.first.id : 0
    }, status: :ok
  end
end
