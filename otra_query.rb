require 'rbvmomi'
dc_name = "DCH_Hatillo"
vmware_url = "10.70.91.56"

# vim = RbVmomi::VIM.connect(host: vmware_url, user: ENV["vmware_user"], password: ENV["vmware_password"], insecure: true)
vim = RbVmomi::VIM.connect(host: vmware_url, user: "capacidades@cantv", password: "Capacidades2017%", insecure: true)
vdc = vim.serviceInstance.find_datacenter(dc_name)

# vhost = vdc.hostFolder.children[0].host[1]

vdc.hostFolder.children[0].host.each do |vhost|
  if vhost.summary.runtime.connectionState != 'connected'
    next
  end
  vhost_mem_total = vhost.hardware.memorySize / 1024.0**3
  vhost_space_total = (vhost.datastore.sum {|x| x.summary.capacity}) / 1024.0**3
  vhost_mem_s = (vhost_mem_total / 1).to_i
  vhost_space_s = (vhost_space_total / 25).to_i

  vhost_space_sobra = vhost_mem_s < vhost_space_s
  vhost_s = (vhost_mem_s < vhost_space_s ? vhost_mem_s : vhost_space_s)
  vhost_sobra = (vhost_space_sobra ? (vhost_space_s - vhost_s) * 25 : (vhost_mem_s - vhost_s) * 1)

  puts "#{vhost.name} Hay #{vhost_mem_s} #{vhost_space_s} instancias: #{vhost_s * 1} GB RAM, #{vhost_s * 25} GB disco y sobra #{vhost_sobra} GB #{vhost_space_sobra ? 'disco' : 'RAM'}"

  suma_mem = vhost.summary.quickStats.overallMemoryUsage / 1024
  suma_space = 0
  suma_guest = 0
  suma_host = 0

  espacio = vhost.vm.sum do |vm|
    (vm.storage.perDatastoreUsage[0].committed / 1024.0**3) + (vm.storage.perDatastoreUsage[0].uncommitted / 1024.0**3)
  end

  mem_s = (suma_mem / 1).to_i
  space_s = (espacio / 25).to_i
  puts "#{vhost.name} usa instancias: #{mem_s} #{space_s}, queda #{vhost_mem_s - mem_s} y #{vhost_space_s - (space_s-mem_s)}"
  puts ""
end