require 'phpipam'

namespace :setup do
  desc "TODO: Setup everything"
  task full: :environment do
  end

  desc "Fills database with initial information for sections from PHPIpam"
  task section: :environment do
    Phpipam.authenticate
    sections = Phpipam::Section.get_all

    sections.each do |section|
      Section.create!(api_id: section.id, name: section.name, description: section.description)
    end
  end

end
