# require 'net/ldap'

class Ldap
  def self.authenticate(username, password)
    conn = Net::LDAP.new :host => ENV["ldap_host"],
          :port => ENV["ldap_port"],
          :auth => {
               :method => :simple,
               :username => "uid=#{username},ou=people,o=dch",
               :password => password
          }
    conn.bind
  end
end