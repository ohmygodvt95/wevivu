class BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
      bookmark = Bookmark.find_by user_id: params[:bookmark][:user_id], post_id: params[:bookmark][:post_id]
      if bookmark.nil?
        bookmark = Bookmark.new post_id: params[:bookmark][:post_id], user_id: params[:bookmark][:user_id]
        if bookmark.save
          render json: { status: 'success', data: 'Make bookmark success'}, status: :ok
        else
          render json: { status: 'failure', data: 'Make Bookmark failure'}, status: 502
        end
      else
        bookmark.destroy
        render json: {status: 'success', data: 'Destroy bookmark success'}, status: :ok
      end
  end
end
