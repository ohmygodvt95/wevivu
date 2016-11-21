class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /posts
  # GET /posts.json
  def show

    @post = Post.find(params[:id])
    arr = [0, 0, 0, 0, 0]
    ratetotal = 0
    for i in 0..4
      arr[i] = @post.rates.where(:point => (i+1)).count
      ratetotal += arr[i]*(i+1)
    end

    ratetb = ratetotal / 5.0
    @image = @post.images
    # @user = User.find(@post.user_id)
    # a = Rate.where(:user_id=>)
    render json: {status: "success", data: {post: @post, rate: arr, rate_tb: ratetb, images: @image}}, status: :ok
  end

  # GET /posts/:id/:page
  def get_comments

    @post = Post.find(params[:id])
    offset = Integer(params[:page])*10

    @comment = @post.comments.limit(10).offset(offset)
    render json: {status: "success", data: {comments: @comment}}, status: :ok
  end

  def new
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
  def create

    @post = Post.new(post_params)

    if @post.save
      params[:images].each do |i|
        Image.new(user_id: @post.user_id, post_id: @post.id, src: i).save

      end
      @image = @post.images
      render json: {status: "success", data: @post, images: @image}, status: :ok

    else
      render json: @post.errors, status: 404
    end
  end


  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    @post = Post.find(params[:id])

    if @post.update(post_params)
      render json: {status: "success", data: {post: @post}}, status: :ok
    else
      render json: @post.errors, status: 404
    end

  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy

    @post = Post.find(params[:id])

    @post.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:user_id, :location_id, :category_id, :title, :body)
  end

end
