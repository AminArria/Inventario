FactoryGirl.define do
  factory :section do
    api_id { Faker::Number.between(1, 10) }
    name { Faker::Pokemon.name }
    description { Faker::Lorem.paragraph(2) }
  end
end
