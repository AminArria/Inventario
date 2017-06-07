class QueryPhpipamJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Phpipam.authenticate

    Phpipam::Section.get_all.each do |ipam_sec|
      puts "Seccion #{ipam_sec.name}"
      section = Section.find_by(api_id: ipam_sec.id)
      unless section
        section = Section.create!(api_id: ipam_sec.id, name: ipam_sec.name, description: ipam_sec.description)
      end

      ipam_sec.subnets.each do |ipam_sub|
        next if ipam_sub.subnet.blank?
        puts "Subred #{ipam_sub.id}: #{ipam_sub.subnet}/#{ipam_sub.mask}"
        subnet = Subnet.find_by(api_id: ipam_sub.id)
        unless subnet
          subnet = Subnet.create!(api_id: ipam_sub.id, base: ipam_sub.subnet, mask: ipam_sub.mask, section: section,description: ipam_sub.description)
        end

        begin
          now = DateTime.now
          active_addresses = []
          ipam_sub.addresses.each do |ipam_addr|
            address = Address.find_by(api_id: ipam_addr.id)
            if address
              unless address.active
                address.update_attributes(active: true)
              end
            else
              address = Address.create!(api_id: ipam_addr.id, ip: ipam_addr.ip, subnet: subnet, active: true)
            end
            active_addresses << address.id
          end

          subnet.addresses.where.not(id: active_addresses).each do |addr|
            addr.update_attributes(active: false)
          end
        rescue Phpipam::RequestFailed => e
          puts "FALLO"
        end
      end
    end
  end
end
