OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

vim = RbVmomi::VIM.connect(host: '10.70.91.56', user: 'capacidades@cantv', password: 'Capacidades2017%')

dc = vim.serviceInstance.find_datacenter('DCH_Hatillo')

clusters = dc.hostFolder.children

# cluster info
clusters[0].stats

# cluster's hosts
hosts = clusters[0].host

# host hardware total in MB and MHz
hosts[1].hardware.memorySize / 1024 / 1024
hosts[1].hardware.cpuInfo.hz / 1000 / 1000 * hosts[1].hardware.cpuInfo.numCpuCores
hosts[1].summary.quickStats.overallMemoryUsage
hosts[1].summary.quickStats.overallCpuUsage
hosts[1].summary.config.name
