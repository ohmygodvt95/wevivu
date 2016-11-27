class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # GET /posts
  # GET /posts.json
  def show
    post = Post.find(params[:id])
    rate = Rate.find_by user_id: current_user.id, post_id: post.id
    render json: {
        status: "success",
        data: {
            post: post.as_json(
                include: [
                    {
                        images: {
                            only: [:id, :src]
                        }
                    },
                    :location,
                    {
                        user: {
                            only: [:name, :avatar]
                        }
                    }
                ]),
            rate: rate
        }
    }, status: :ok

  end

  def new
    @post = Post.new
  end

  # POST /posts
  # POST /posts.json
  def create

    post = Post.new(post_params)
    post.location = Location.create(name: params[:post][:location][:name], lat: params[:post][:location][:lat], long: params[:post][:location][:long])
    if post.save
      params[:post][:images].each do |i|
        img = Image.find(i[:id])
        img.update(active: 1, post_id: post.id)
      end

      render json: {
          status: "success",
          data: post.as_json(
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
                  :rates
              ])}, status: :ok

    else
      render json: post.errors, status: 404
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
    post = Post.find(params[:id])
    if post.destroy
      render json: {status: "success", data: {id: params[:id]}}, status: :ok
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
