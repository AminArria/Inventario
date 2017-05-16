require 'phpipam'

namespace :setup do
  desc "TODO: Setup everything"
  task full: :environment do
  end

  desc "Fills database with initial information for sections from PHPIpam"
  task section: :environment do
    Phpipam.authenticate

    Phpipam::Section.get_all.each do |sec|
      Section.create(api_id: sec.id, name: sec.name, description: sec.description)
    end
  end

end
