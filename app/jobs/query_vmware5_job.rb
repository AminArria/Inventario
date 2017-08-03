class QueryVmware5Job < ApplicationJob
  queue_as :default

  def perform(*args)
    vim = RbVmomi::VIM.connect(host: ENV["vmware5_url"], user: ENV["vmware_user"], password: ENV["vmware_password"])

    vdc = vim.serviceInstance.find_datacenter('DCH_Hatillo')
    dc = DataCenter.find_by(name: 'DCH_Hatillo')
    unless dc
      dc = DataCenter.create!(name: 'DCH_Hatillo')
    end

    vdc.hostFolder.children.each do |vcluster|
      cluster = Cluster.find_by(name: vcluster.name)
      unless cluster
        cluster = Cluster.new(name: vcluster.name)
        cluster.data_center = dc
      end

      # cluster info
      {:totalCPU=>183968, :totalMem=>653236, :usedCPU=>87102, :usedMem=>431940}
      cluster.memory_total = vcluster.stats[:totalMem]
      cluster.cpu_total = vcluster.stats[:totalCPU]
      cluster.memory_used = vcluster.stats[:usedMem]
      cluster.cpu_used = vcluster.stats[:usedCPU]

      cluster.save!

      vcluster.host.each do |vhost|
        host = Host.find_by(name: vhost.name)
        unless host
          host = Host.new(name: vhost.name)
          host.cluster = cluster
        end

        # host hardware total in MB and MHz
        host.memory_total = vhost.hardware.memorySize / 1024 / 1024
        host.cpu_total = vhost.hardware.cpuInfo.hz / 1000 / 1000 * vhost.hardware.cpuInfo.numCpuCores
        host.memory_used = vhost.summary.quickStats.overallMemoryUsage
        host.cpu_used = vhost.summary.quickStats.overallCpuUsage

        host.save!
      end
    end
  end
end
