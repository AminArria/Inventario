FactoryGirl.define do
  factory :address do
    api_id { Faker::Number.between(1, 10) }
    ip { Faker::Internet.ip_v4_address }
    subnet
  end
end
