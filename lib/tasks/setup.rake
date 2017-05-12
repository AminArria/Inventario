require 'phpipam'

namespace :setup do
  desc "TODO: Setup everything"
  task full: :environment do
  end

  desc "Fills database with initial information for sections from PHPIpam"
  task section: :environment do
    Phpipam.authenticate
    puts Phpipam::Section.get_all
  end

end
