FactoryGirl.define do
  factory :host do
    cpu_total { Faker::Number.decimal(6,2).to_f }
    cpu_used { cpu_total * Faker::Number.decimal(0).to_f }
    memory_total { Faker::Number.decimal(6,2).to_f }
    memory_used { memory_total * Faker::Number.decimal(0).to_f }
    cluster
  end
end
