class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # # GET /comments/:post_id?page=x
  # # GET /comments/
  def show
    @post = Post.find(params[:post_id])
    @comments = Comment.page(params[:page]).per(10).where(post_id: @post)
    render json: {status: "success", data: {comments: @comments.as_json( include: {user: {only: [:id, :name, :avatar]}})}}, status: :ok
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
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: {status: "success", data: {comment: @comment}}, status: :ok
    else
      render json: @comment.errors, status: 404
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
    @comment = Comment.find(params[:id])
    @comment.destroy
    render json: {status: "success"}, status: :ok

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:user_id, :post_id, :body)
  end
end
