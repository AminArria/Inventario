class ReportsController < ApplicationController
  def general
    @public_ip_count = Section.addresses_count(public: true)
    @private_ip_count = Section.addresses_count(public: false)
    @subnets = Subnet.all
    @dedicated_hosting = DataCenter.global_instance_stats
    @clusters = Cluster.all
    render xlsx: 'general', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  def new
  end

  def create
    @public_ip_count = nil
    @private_ip_count = nil
    @subnets = []
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

    render xlsx: 'create', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  private
    def xls_date_format(date)
      date.strftime('%d_%m_%Y')
    end
end
