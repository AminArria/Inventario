class AggregatesController < ApplicationController
  before_action :set_aggregate, only: [:show]
  before_action :set_storage_box, only: [:index]

  # GET /aggregates
  def index
    @aggregates = @storage_box.aggregates
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aggregate
      @aggregate = Aggregate.find(params[:id])
    end

    def set_storage_box
      @storage_box = StorageBox.find(params[:storage_box_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:aggregate)
    end
end
