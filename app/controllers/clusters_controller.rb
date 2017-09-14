class ClustersController < ApplicationController
  before_action :set_cluster, only: [:show]
  before_action :set_data_center, only: [:index]

  def index
    @clusters = @data_center.clusters
  end

  def show
  end

  private
    def set_cluster
      @cluster = Cluster.find(params[:id])
    end

    def set_data_center
      @data_center = DataCenter.find(params[:data_center_id])
    end
end
