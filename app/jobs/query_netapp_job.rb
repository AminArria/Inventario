require 'net/telnet'

class QueryNetappJob < ApplicationJob
  queue_as :default

  def perform(host)
    localhost = Net::Telnet::new("Host" => host, "Timeout" => 10, "Prompt" => /ntap[123][ab]>/)
    localhost.login(ENV["netapp_user"], ENV["netapp_password"])

    hostname = localhost.cmd("hostname").gsub(/\n/, ' ').split[1]

    netapp_host = StorageBox.find_by(name: hostname)
    unless netapp_host
      netapp_host = StorageBox.create!(name: hostname)
    end

    response = localhost.cmd("aggr show_space")

    data = response.gsub(/\n/, ' ').split.drop(3)

    aggregates = []
    index = 0

    while(index < data.count)
      aggr_index = data[index..-1].find_index('Aggregate') + index
      aggr = Aggregate.find_by(name: data[index][1..-2], storage_box: netapp_host)
      unless aggr
        aggr = Aggregate.create!(name: data[index][1..-2], storage_box: netapp_host, space_total: 0, space_used: 0)
      end

      aggr.update_attributes!(space_total: data[index+15][0..-3].to_f, space_used: data[aggr_index+6][0..-3].to_f)

      vol_index = data[index..-1].find_index('Volume') + 4 + index

      while vol_index < aggr_index
        vol_name = data[vol_index]
        vol_response = localhost.cmd("df -V #{vol_name}")
        vol_data = vol_response.gsub(/\n/, ' ').split.drop(10)

        vol = Volume.find_by(name: vol_name, aggregate: aggr)
        unless vol
          vol = Volume.create!(name: vol_name, aggregate: aggr, space_total: 0, space_used: 0)
        end

        vol.update_attributes!(space_total: vol_data[1].to_f, space_used: vol_data[2].to_f)
        vol_index += 4
      end

      aggr.save!
      index = aggr_index + 20
    end

    localhost.close
  end
end
