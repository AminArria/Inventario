require 'ruby_phpipam'

RubyPhpipam.configure do |config|
  config.base_url = ENV["phpipam_base_url"]
  config.username = ENV["phpipam_username"]
  config.password = ENV["phpipam_password"]
end