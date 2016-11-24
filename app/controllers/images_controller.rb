class ImagesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create

    img = Image.new user_id: current_user.id, src: params[:file]

    if img.save
      render json: { status: 'success', data: img}, status: 200
    else
      render json: { status: 'failure', data: nil}, status: :bad_gateway
    end
  end

  def show
    @image = Image.find(params[:id])
    render json: {status: "success", data: {image: @image}}, status: :ok
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    @image = Image.find(params[:id])
    if @image.update(image_params)
      render json: {status: "success", data: {image:@image}}, status: :ok
    else
      render json: @comment.errors, status: 404
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy
    render json: {status: "success"}, status: :ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:user_id, :post_id, :title, :src)
  end
end
