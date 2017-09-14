class QueryVmwareJob < ApplicationJob
  queue_as :default

  def perform(vmware_url, dc_name)
    # stats are expressed in:
    #   CPU     -> GHz
    #   memory  -> GB
    #   disk    -> GB

    vim = RbVmomi::VIM.connect(host: vmware_url, user: ENV["vmware_user"], password: ENV["vmware_password"], insecure: true)

    vdc = vim.serviceInstance.find_datacenter(dc_name)
    dc = DataCenter.find_by(name: dc_name)
    unless dc
      dc = DataCenter.create!(name: dc_name)
    end

    dc.disk_total = 0.0
    dc.disk_used = 0.0
    vdc.datastore.each do |ds|
        dc.disk_total += ds.summary.capacity
        dc.disk_used += ds.summary.freeSpace
      end

    disk_total /= 1024.0**3
    disk_used /= 1024.0**3
    dc.save!

    vdc.hostFolder.children.each do |vcluster|
      cluster = Cluster.find_by(name: vcluster.name)
      unless cluster
        cluster = Cluster.create!(name: vcluster.name, data_center: dc)
      end

      cluster.cpu_total = vcluster.summary.effectiveCpu / 1000.0
      cluster.memory_total = vcluster.summary.effectiveMemory / 1024.0
      cluster.disk_total = 0.0
      cluster.physical_cores = vcluster.summary.numCpuCores
      cluster.hosts_total = vcluster.summary.numHosts
      cluster.hosts_active = vcluster.summary.numEffectiveHosts
      cluster.cpu_used = 0.0
      cluster.memory_used = 0.0
      cluster.disk_used = 0.0
      cluster.virtual_cores = 0

      vcluster.datastore.each do |ds|
        cluster.disk_total += ds.summary.capacity
        cluster.disk_used += ds.summary.freeSpace
      end

      cluster.disk_used = cluster.disk_total - cluster.disk_used
      cluster.disk_total /= 1024.0**3
      cluster.disk_used /= 1024.0**3

      vcluster.host.each do |vhost|
        host = Host.find_by(name: vhost.name)
        unless host
          host = Host.new(name: vhost.name, cluster: cluster)
        end

        host.cpu_total = vhost.hardware.cpuInfo.hz * vhost.hardware.cpuInfo.numCpuCores / 1000.0**3
        host.memory_total = vhost.hardware.memorySize / 1024.0**3
        host.disk_total = (vhost.datastore.sum {|x| x.summary.capacity}) / 1024.0**3
        host.physical_cores = vhost.summary.hardware.numCpuCores
        host.cpu_used = (vhost.summary.quickStats.overallCpuUsage || 0) / 1000.0
        host.memory_used = (vhost.summary.quickStats.overallMemoryUsage || 0) / 1024.0
        host.disk_used = 0
        host.virtual_cores = 0

        vhost.vm.each do |vm|
          if vm.summary.runtime.connectionState != "connected"
            next
          else
            host.disk_used += (vm.storage.perDatastoreUsage[0].committed / 1024.0**3) + (vm.storage.perDatastoreUsage[0].uncommitted / 1024.0**3)
            host.virtual_cores += vm.summary.config.numCpu
          end
        end

        host.save!

        if vhost.summary.runtime.connectionState == 'connected'
          cluster.cpu_used += host.cpu_used
          cluster.memory_used += host.memory_used
          cluster.virtual_cores += host.virtual_cores
        end
      end

      cluster.save!
    end
  end
end
