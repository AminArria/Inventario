class ReportsController < ApplicationController
  def general
    # Network
    @public_ip_count = Section.addresses_count(public: true)
    @private_ip_count = Section.addresses_count(public: false)
    @subnets = Subnet.all

    # Hosting
    @virtual_hosting = DataCenter.stats
    @clusters = Cluster.all

    # Storage
    @nas_storage = StorageBox.nas_stats
    @volumes = Volume
                .joins(aggregate: :storage_box)
                .select('storage_boxes.name as sb_name, aggregates.name as aggr_name, volumes.*')
                .order('sb_name, aggr_name, volumes.name')

    render xlsx: 'general', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  def new
  end

  def create
    # Network
    @public_ip_count = nil
    @private_ip_count = nil
    @subnets = []
    @network_individual = (params[:network][:individual] == "true")
    if params[:network][:active] == "true"
      if params[:network][:public]
        @public_ip_count = Section.addresses_count(public: true)
        @subnets = @subnets + Subnet.where(public: true)
      end
      if params[:network][:private]
        @private_ip_count = Section.addresses_count(public: false)
        @subnets = @subnets + Subnet.where(public: false)
      end
    end

    # Hosting
    @virtual_hosting = nil
    @clusters = []
    @virtual_hosting_individual = (params[:hosting][:virtual_individual] == "true")
    if params[:hosting][:virtual] == "true"
      @virtual_hosting = DataCenter.stats
      @clusters = Cluster.all if @virtual_hosting_individual
    end

    # Storage
    @nas_storage = nil
    @aggregates = []
    @nas_storage_individual = (params[:storage][:nas_individual] == "true")
    if params[:storage][:nas] == "true"
      @nas_storage = StorageBox.nas_stats
      @volumes = Volume
                  .joins(aggregate: :storage_box)
                  .select('storage_boxes.name as sb_name, aggregates.name as aggr_name, volumes.*')
                  .order('sb_name, aggr_name, volumes.name') if @nas_storage_individual
    end

    render xlsx: 'create', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  private
    def xls_date_format(date)
      date.strftime('%d_%m_%Y')
    end
end
