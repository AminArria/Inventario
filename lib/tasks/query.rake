namespace :query do
  desc "Queue system wide queries"
  task all: :environment do
    QueryPhpipam.enqueue
  end

  desc "Queue a query to phpipam"
  task phpipam: :environment do
    QueryPhpipam.enqueue
  end
end
