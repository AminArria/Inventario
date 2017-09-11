require 'rbvmomi'
dc_name = "DCH_Hatillo"
vmware_url = "10.70.91.56"

# vim = RbVmomi::VIM.connect(host: vmware_url, user: ENV["vmware_user"], password: ENV["vmware_password"], insecure: true)
vim = RbVmomi::VIM.connect(host: vmware_url, user: "capacidades@cantv", password: "Capacidades2017%", insecure: true)
vdc = vim.serviceInstance.find_datacenter(dc_name)

vhost = vdc.hostFolder.children[0].host[1]

vhost_mem_total = vhost.hardware.memorySize / 1024.0**3
vhost_space_total = (vhost.datastore.sum {|x| x.summary.capacity}) / 1024.0**3
vhost_mem_s = (vhost_mem_total / 1).to_i
vhost_space_s = (vhost_space_total / 25).to_i

vhost_space_sobra = vhost_mem_s < vhost_space_s
vhost_s = (vhost_mem_s < vhost_space_s ? vhost_mem_s : vhost_space_s)
vhost_sobra = (vhost_space_sobra ? (vhost_space_s - vhost_s) * 25 : (vhost_mem_s - vhost_s) * 1)

puts "Hay #{vhost_s} instancias: #{vhost_s * 1} GB RAM, #{vhost_s * 25} GB disco y sobra #{vhost_sobra} GB #{vhost_space_sobra ? 'disco' : 'RAM'}"

suma_mem = 0
suma_space = 0
suma_guest = 0
suma_host = 0
espacio = 0

vhost.vm.each do |vm|
  vm_mem = vm.summary.quickStats.hostMemoryUsage / 1024
  vm_mem_s =  (vm_mem / 1).to_i
  vm_space = (vm.storage.perDatastoreUsage[0].committed / 1024.0**3) + (vm.storage.perDatastoreUsage[0].uncommitted / 1024.0**3)
  vm_space_s = (vm_space / 25).to_i

  puts "    vm(#{vm.name}) usa #{vm_mem_s} instancias memoria y #{vm_space_s} instancias disco"
  suma_mem += vm_mem_s
  suma_space += vm_space_s
  suma_guest += vm.summary.quickStats.guestMemoryUsage
  suma_host += vm.summary.quickStats.hostMemoryUsage
  espacio += vm_space
=begin
  if vhost_space_sobra
    vm_s = vm_mem_s
    vhost_sobra = vhost_sobra + ((vm_mem_s - vm_space_s) * 25) - (vm_space % 25 )
  else
    vm_s = vm_space_s
    vhost_sobra = vhost_sobra + ((vm_space_s - vm_mem_s) * 1) - (vm_mem % 1 )
  end

  vhost_s -= vm_s
  if vhost_sobra < 0
    if vhost_space_sobra
      mem_s = vhost_s
      vhost_s -= (vhost_sobra / 25).to_i
      vhost_space_sobra = false
      vhost_sobra = (mem_s - vhost_s) * 1
    else
      space_s = vhost_s
      vhost_s -= (vhost_sobra / 1).to_i
      vhost_space_sobra = true
      vhost_sobra = (space_s - vhost_s) * 25
    end
  end
  puts "Hay #{vhost_s} instancias: #{vhost_s * 1} GB RAM, #{vhost_s * 25} GB disco y sobra #{vhost_sobra} GB #{vhost_space_sobra ? 'disco' : 'RAM'}"
=end
end
puts "resultados: #{suma_mem} instancias memoria y #{suma_space} instancias disco"
puts "Memoria -> guest: #{suma_guest}     host: #{suma_host}"
puts "Disco: #{espacio}"