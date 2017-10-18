class StorageBoxesController < ApplicationController
  before_action :set_storage_box, only: [:show]

  # GET /storage_boxes
  def index
    @storage_boxes = StorageBox.all
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storage_box
      @storage_box = StorageBox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:storage_box)
    end
end
