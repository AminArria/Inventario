class ReportsController < ApplicationController
  def general
    render xlsx: 'general', filename: "Informe_Capacidades_#{xls_date_format(DateTime.now)}"
  end

  private
    def xls_date_format(date)
      date.strftime('%d_%m_%Y')
    end
end
