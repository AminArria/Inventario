namespace :query do
  desc "Queue a query to phpipam"
  task phpipam: :environment do
    QueryPhpipam.enqueue
  end
end
