class HomeController < ApplicationController
  MAX = 9999999999999999

  def index
  end

  #home/:type/:pages
  def get_posts
    case params[:type]
      when 'me'
        realtime_page_next_by_me Integer(params[:user_id]), Integer(params[:after]), Integer(params[:limit])
      when 'rates'
        realtime_page_next_by_rate Integer(params[:after]), Integer(params[:limit])
      when 'search'
        realtime_page_next_by_search Integer(params[:after]), Integer(params[:limit]), params[:query]
      when 'bookmarks'
        realtime_page_next_by_bookmark Integer(params[:user_id]), Integer(params[:after]), Integer(params[:limit]), params[:query]
      else
        realtime_page_next_by_time Integer(params[:after]), Integer(params[:limit]), params[:query]
    end
  end


  private

  def realtime_page_next_by_rate(after, limit)
    after = MAX if after <= 0
    list = Rate.group(:post_id).order("count_all desc").includes(:post).limit(50).count
    posts = []
    list.each do |item|
      posts.append Post.find item[0]
    end
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
        limit: limit,
        after: MAX,
        before: 0
    }, status: :ok
  end

  def realtime_page_next_by_bookmark(user_id, after, limit, query)
    after = MAX if after <= 0

    if query.length == 0
      bookmarks = Bookmark.where('user_id = ? AND id < ?', user_id, after).order(id: :desc).limit limit
      posts = []
      bookmarks.each do |item|
        posts.append item.post unless item.post.nil?
      end
    else
      locations = Location.where("name like '%#{query}%'").page 1
      posts = []
      locations.each do |item|
        posts.append item.post unless item.post.nil?
      end
    end

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
        limit: limit,
        after: posts.count == 0 ? after : bookmarks.last.id,
        before: after == MAX ? (posts.count == 0 ? 0 : bookmarks.last.id) : 0
    }, status: :ok
  end

  def realtime_page_next_by_me(user_id, after, limit)
    after = MAX if after <= 0
    posts = Post.where("id < ? AND user_id = ?", after, user_id).order(id: :desc).limit limit

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
        limit: limit,
        after: posts.count == 0 ? after : posts.last.id,
        before: after == MAX ? (posts.count == 0 ? 0 : posts.last.id) : 0
    }, status: :ok
  end

  def realtime_page_next_by_search(after, limit, query)
    after = MAX if after <= 0

    q = Post.ransack body_cont: query, location_name_cont: query, user_name_cont: query, user_email_cont: query, m: 'or'
    posts = q.result.where("posts.id < ?", after).limit limit

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
        limit: limit,
        after: posts.count == 0 ? after : posts.last.id,
        before: after == MAX ? (posts.count == 0 ? 0 : posts.last.id) : 0
    }, status: :ok
  end

  def realtime_page_next_by_time(after, limit, query)
    after = MAX if after <= 0
    if query.length == 0
      posts = Post.where("id < ?", after).order(id: :desc).limit limit
    else
      locations = Location.where("name like '%#{query}%' AND id < after").order(id: :desc).limit limit
      posts = []
      locations.each do |item|
        posts.append item.post unless item.post.nil?
      end
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
          limit: limit,
          after: posts.count == 0 ? after : locations.last.id,
          before: after == MAX ? (posts.count == 0 ? 0 : locations.last.id) : 0
      }, status: :ok
    end

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
        limit: limit,
        after: posts.count == 0 ? after : posts.last.id,
        before: after == MAX ? (posts.count == 0 ? 0 : posts.last.id) : 0
    }, status: :ok
  end
end
