dc_name = "DCH_Hatillo"
vmware_url = "10.70.91.56"

vim = RbVmomi::VIM.connect(host: vmware_url, user: ENV["vmware_user"], password: ENV["vmware_password"], insecure: true)
vdc = vim.serviceInstance.find_datacenter(dc_name)

def vms(folder) # recursively go thru a folder, dumping vm info
   valores = []
   folder.childEntity.each do |x|
      name, junk = x.to_s.split('(')
      case name
      when "Folder"
         valores.concat(vms(x))
      when "VirtualMachine"
         # if x.summary.runtime.maxCpuUsage
            # valores << x.summary.runtime.maxCpuUsage
            valores << x.summary.config.memorySizeMB
         # else
            # puts "VirtualMachine nil maxCpuUsage -> #{x.name}"
         # end
      else
         puts "# Unrecognized Entity " + x.to_s
      end
   end
   return valores
end

# vm.summary.config.memorySizeMB
# vm.summary.config.numCpu
# vm.storage.perDatastoreUsage[0].committed / 1024**3
# vm.storage.perDatastoreUsage[0].uncommitted / 1024**3