class ReportsController < ApplicationController
  def general
    @ip_count = Section.addresses_count(public: true)
    @subnets = Subnet.where(public: true)
    render xlsx: 'general', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  private
    def xls_date_format(date)
      date.strftime('%d_%m_%Y')
    end
end
