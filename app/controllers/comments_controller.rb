class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # # GET /comments/1
  # # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])
      render json: {status: "success", data: {comment: @comment}}, status: :ok
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
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
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
