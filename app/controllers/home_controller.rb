class HomeController < ApplicationController
  def index
  end

  #home/:type/:pages
  def get_posts
    case params[:type]
      when 'rates'
      when 'bookmarks'
      else
        posts = Post.page(params[:page]).per(20).order(id: :desc)
        render json: {
            status: 'success',
            data: posts.as_json(
                include: [
                    {user:
                         {only: [:id, :name, :avatar]}
                    },
                    :location,
                    :images,
                    :rates
                ]),
            total: posts.count,
            page: Integer(params[:page])
        }, status: :ok
    end
  end
end
