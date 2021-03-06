FactoryGirl.define do
  factory :host do
    name { Faker::Pokemon.name }
    cpu_total { Faker::Number.decimal(6,2).to_f }
    cpu_used { cpu_total * Faker::Number.decimal(0).to_f }
    memory_total { Faker::Number.decimal(6,2).to_f }
    memory_used { memory_total * Faker::Number.decimal(0).to_f }
    disk_total { Faker::Number.decimal(6,2).to_f }
    disk_used { disk_total * Faker::Number.decimal(0).to_f }
    physical_cores { Faker::Number.number(2) }
    virtual_cores { Faker::Number.number(2) }
    cluster
  end
end
