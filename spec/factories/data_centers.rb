FactoryGirl.define do
  factory :data_center do
    name { Faker::Pokemon.name }
    disk_total { Faker::Number.decimal(6,2).to_f }
    disk_used { disk_total * Faker::Number.decimal(0).to_f }
  end
end
