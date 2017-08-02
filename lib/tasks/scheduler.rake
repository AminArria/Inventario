namespace :scheduler do
  desc "Every 30 minutes"
  task every_30_minutes: :environment do
    QueryPhpipamJob.perform_later
  end
end
