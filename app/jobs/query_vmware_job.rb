class QueryVmwareJob < ApplicationJob
  queue_as :default

  def perform(vmware_url, dc_name)
    vim = RbVmomi::VIM.connect(host: vmware_url, user: ENV["vmware_user"], password: ENV["vmware_password"], insecure: true)

    vdc = vim.serviceInstance.find_datacenter(dc_name)
    dc = DataCenter.find_by(name: dc_name)
    unless dc
      dc = DataCenter.create!(name: dc_name)
    end

    vdc.hostFolder.children.each do |vcluster|
      cluster = Cluster.find_by(name: vcluster.name)
      unless cluster
        cluster = Cluster.new(name: vcluster.name)
        cluster.data_center = dc
      end

      # cluster info
      cluster.memory_total = 0
      cluster.cpu_total = 0
      cluster.memory_used = 0
      cluster.cpu_used = 0

      vcluster.host.each do |vhost|
        host = Host.find_by(name: vhost.name)
        unless host
          host = Host.new(name: vhost.name)
          host.cluster = cluster
        end

        # host hardware total in MB and MHz
        host.memory_total = vhost.hardware.memorySize / 1024 / 1024
        host.cpu_total = vhost.hardware.cpuInfo.hz * vhost.hardware.cpuInfo.numCpuCores / 1000 / 1000
        host.memory_used = vhost.summary.quickStats.overallMemoryUsage
        host.cpu_used = vhost.summary.quickStats.overallCpuUsage
        host.save!

        if vhost.summary.runtime.connectionState == 'connected'
          cluster.memory_total += host.memory_total
          cluster.cpu_total += host.cpu_total
          cluster.memory_used += host.memory_used
          cluster.cpu_used += host.cpu_used
        end
      end

      cluster.save!
    end
  end
end
