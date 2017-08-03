require 'rails_helper'

RSpec.describe Host, type: :model do
  it 'has a valid factory' do
    expect(build(:host)).to be_valid
  end

  it 'is invalid with negative cpu_total' do
    host = build(:host, cpu_total: -1)
    host.valid?
    expect(host.errors[:cpu_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative cpu_used' do
    host = build(:host, cpu_used: -1)
    host.valid?
    expect(host.errors[:cpu_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative memory_total' do
    host = build(:host, memory_total: -1)
    host.valid?
    expect(host.errors[:memory_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative memory_used' do
    host = build(:host, memory_used: -1)
    host.valid?
    expect(host.errors[:memory_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid if cpu_used is greater than cpu_total' do
    host = build(:host, cpu_total: 10, cpu_used: 11)
    host.valid?
    expect(host.errors[:cpu_used]).to include("must be less than or equal to 10.0")
  end

  it 'is invalid if memory_used is greater than memory_total' do
    host = build(:host, memory_total: 10, memory_used: 11)
    host.valid?
    expect(host.errors[:memory_used]).to include("must be less than or equal to 10.0")
  end
end
