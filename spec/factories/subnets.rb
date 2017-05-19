FactoryGirl.define do
  factory :subnet do
    api_id { Faker::Number.between(1, 10) }
    base { Faker::Internet.ip_v4_address }
    mask { Faker::Number.between(0, 32) }
    section
    description { Faker::Lorem.paragraph(2) }

    factory :subnet_hosts do
      max_hosts { Faker::Number.between(10, 20) }
      used_hosts { Faker::Number.between(1, 10) }
    end
  end
end
