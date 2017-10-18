class VolumesController < ApplicationController
  before_action :set_volume, only: [:show]
  before_action :set_aggregate, only: [:index]

  # GET /volumes
  def index
    @volumes = @aggregate.volumes
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_volume
      @volume = Volume.find(params[:id])
    end

    def set_aggregate
      @aggregate = Aggregate.find(params[:aggregate_id])
    end
end
