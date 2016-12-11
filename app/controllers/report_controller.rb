class ReportController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    report = Report.new
    report.user_id = params[:report][:user_id]
    report.post_id = params[:report][:post_id]
    if report.save
      render json: {status: "success", data: "Report created!"}, status: :ok
    else
      render json: {status: "failure", data: "Report error!"}, status: :ok
    end
  end

end
