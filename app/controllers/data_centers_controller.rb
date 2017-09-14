class DataCentersController < ApplicationController
  before_action :set_data_center, only: [:show]

  # GET /data_centers
  def index
    @data_centers = DataCenter.all
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_center
      @data_center = DataCenter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:data_center).permit(:api_id, :name, :description)
    end
end
