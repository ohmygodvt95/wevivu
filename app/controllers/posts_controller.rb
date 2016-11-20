class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /posts
  # GET /posts.json
  def show
    @post = Post.find(params[:id])
    arr = [0, 0, 0, 0, 0]
    for i in 0..4
      arr[i] = @post.rates.where(:point => (i+1)).count
    end
    if (arr[0] + arr[1] + arr[2] + arr[3] + arr[4]) != 0
      rate_tb = (arr[0] * 1 + arr[1] * 2 + arr[2] * 3 + arr[3] * 4 + arr[4] * 5) /
          (arr[0] + arr[1] + arr[2] + arr[3] + arr[4])
    else
      rate_tb = 0
    end
    @comment = @post.comments.last(10)
    render json: {status: "success", data: {post: @post.as_json(include: [:images,:location,{user: {only: [:name,:avatar]}} ]) , rate: arr, rate_tb: rate_tb,comments:@comment.as_json(include: {user: {only: [:id, :name, :avatar]}})}}, status: :ok

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
      @location = Location.find(params[:id_location])
      render json: {status: "success", data: @post, location: @location, images: @image}, status: :ok

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
    render json: {status: "success"}, status: :ok
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
