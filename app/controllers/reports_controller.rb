class ReportsController < ApplicationController
  def general
    @public_ip_count = Section.addresses_count(public: true)
    @private_ip_count = Section.addresses_count(public: false)
    @subnets = Subnet.all
    render xlsx: 'general', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  private
    def xls_date_format(date)
      date.strftime('%d_%m_%Y')
    end
end
