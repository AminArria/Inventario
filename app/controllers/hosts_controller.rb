class HostsController < ApplicationController
  before_action :set_host, only: [:show]
  before_action :set_cluster, only: [:index]

  def index
    @hosts = @cluster.hosts
  end

  def show
  end

  private
    def set_host
      @host = Host.find(params[:id])
    end

    def set_cluster
      @cluster = Cluster.find(params[:cluster_id])
    end
end
