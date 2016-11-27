class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  MAX = 99999999999999999999999
  # # GET /comments/:post_id?page=x
  # # GET /comments/
  def show
    realtime_page_next_by_time Integer(params[:post_id]), Integer(params[:after]), Integer(params[:limit])
  end

  #
  # GET /comments/new
  # def new
  #   @comment = Comment.new
  # end
  #
  # # POST /comments
  # # POST /comments.json
  def create
    comment = Comment.new(comment_params)

    post = Post.find(params[:comment][:post_id])
    post.data["comments"] = post.data["comments"] + 1

    if comment.save && post.save
      render json: {
          status: "success",
          data: {
              comment: comment.as_json(include: {
                  user: {
                      only: [:id, :name, :avatar]
                  }
              }),
              comments: post.data["comments"]
          }
      }, status: :ok
    else
      render json: comment.errors, status: 404
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      render json: {status: "success", data: {comment: @comment}}, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    comment = Comment.find(params[:id])
    if current_user.id == comment.user_id
      post = comment.post
      post.data['comments'] = post.data['comments'] - 1
      if comment.destroy && post.save
        render json: {status: "success", data: {id: Integer(params[:id]), comments: post.data['comments']}}, status: :ok
      else
        render json: {status: "failure", data: nil}, status: 404
      end

    else
      render json: {status: "failure", data: nil}, status: 404
    end
  end

  private
  def realtime_page_next_by_time(post_id, after, limit)
    after = MAX if after <= 0
    comments = Comment.where("id < ? and post_id = ?", after, post_id).order(id: :desc).limit(limit)
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
        limit: limit,
        after: comments.count == 0 ? after : comments.last.id,
        before: after == MAX ? (comments.count == 0 ? 0 : comments.last.id) : 0
    }, status: :ok
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :body)
  end
end
