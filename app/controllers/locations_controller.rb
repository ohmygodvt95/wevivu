class LocationsController < ApplicationController

  def show
    begin
      @local = Location.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      @local = nil
    end

    if @local.nil?
      render json:{status: "failure", data: @local}, status: 404
    else
      render json: {status: "success", data: @local}, status: 200
    end
  end

  def search
    keyword=params[:keyword]
    localtion_array=[]
    letter_arr=keyword.split(' ')
    letter_arr.each do |a|
      tmp=Location.where("keywords like ?","%#{a}%")

      localtion_array << tmp unless localtion_array.include? tmp

    end

    render json: {status: "success", data: localtion_array.uniq{ |x| x[:keywords]}}, status: 200

  end



end




