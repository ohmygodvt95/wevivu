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
    #arr chinnh
    location_array=[]
    letter_arr=keyword.split(' ')
    letter_arr.each do |a|
      tmp=Location.where("keywords like ?","%#{a}%" )
      tmp.each do |ele|
        #check duplicate de khong add vao array
        if(location_array.include?ele)
        else
          location_array << ele
        end


      end
    end

    render json: {status: "success", data: location_array}, status: 200

  end



end




