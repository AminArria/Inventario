FactoryGirl.define do
  factory :subnet do
    api_id 1
    base "MyString"
    mask 1
    section ""
    description "MyText"
  end
end
