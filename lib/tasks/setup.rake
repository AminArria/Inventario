require 'phpipam'

namespace :setup do
  desc "Fetches initial information from PHPIpam"
  task full: :environment do
    subnets_malas = []
    puts "Fetching information from #{Phpipam.configuration.base_url}"
    Phpipam.authenticate

    # Transaction should be added. Maybe nested transactions
    # Get sections
    Phpipam::Section.get_all.each do |sec|
      puts "Fetching details of section #{sec.id}: #{sec.name}"
      section = Section.create!(api_id: sec.id, name: sec.name, description: sec.description)

      # For each section get its subnets
      sec.subnets.each do |sub|
        puts "Fetching details of subnet #{sub.id}: #{sub.subnet}/#{sub.mask}"
        #next if sub.id == 81
        subnet = Subnet.create!(api_id: sub.id, base: sub.subnet, mask: sub.mask, section: section, description: sub.description)

        # For each subnet get its addresses
        begin
          sub.addresses.each do |addr|
            Address.create!(api_id: addr.id, ip: addr.ip, subnet: subnet, active: true)
          end
        rescue Phpipam::RequestFailed => e
          subnets_malas << sub.id
        end
      end
    end

    puts subnets_malas
  end

  desc "Fetches information for sections from PHPIpam"
  task sections: :environment do
    Phpipam.authenticate
    puts Phpipam::Section.get_all
  end

  desc "Fetches information from PHPIpam for subnets given a section"
  task subnets: :environment do
    Phpipam.authenticate

    Phpipam::Subnet.get_all.each do |sub|
      Subnet.create(api_id: sub.id, base: sub.base, mask: sub.mask, section_id: sub.sectionId, description: sub.description)
    end
  end

  desc "Fetches information from PHPIpam for addresses given a subnet"
  task addresses: :environment do
    Phpipam.authenticate

    Phpipam::Address.get_all.each do |addr|
      Address.create(api_id: addr.id, ip: addr.ip, subnet_id: addr.subnetId, active: true)
    end
  end

end
