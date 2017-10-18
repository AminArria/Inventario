namespace :scheduler do
  desc "Every 30 minutes"
  task every_30_minutes: :environment do
    QueryPhpipamJob.perform_later

    QueryVmwareJob.perform_later(ENV["vmware5_url"], "DCH_Hatillo")
    QueryVmwareJob.perform_later(ENV["vmware6_url"], "DCH")

    ENV["netapp_hosts"].split.each do |host|
      QueryNetappJob.perform_later(host)
    end
  end
end
