require 'rails_helper'

RSpec.describe Cluster, type: :model do
  it 'has a valid factory' do
    expect(build(:cluster)).to be_valid
  end

  it 'is invalid with no name' do
    host = build(:host, name: nil)
    host.valid?
    expect(host.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with negative cpu_total' do
    cluster = build(:cluster, cpu_total: -1)
    cluster.valid?
    expect(cluster.errors[:cpu_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative cpu_used' do
    cluster = build(:cluster, cpu_used: -1)
    cluster.valid?
    expect(cluster.errors[:cpu_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative memory_total' do
    cluster = build(:cluster, memory_total: -1)
    cluster.valid?
    expect(cluster.errors[:memory_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative memory_used' do
    cluster = build(:cluster, memory_used: -1)
    cluster.valid?
    expect(cluster.errors[:memory_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid if cpu_used is greater than cpu_total' do
    cluster = build(:cluster, cpu_total: 10, cpu_used: 11)
    cluster.valid?
    expect(cluster.errors[:cpu_used]).to include("must be less than or equal to 10.0")
  end

  it 'is invalid if memory_used is greater than memory_total' do
    cluster = build(:cluster, memory_total: 10, memory_used: 11)
    cluster.valid?
    expect(cluster.errors[:memory_used]).to include("must be less than or equal to 10.0")
  end

  it 'returns the amount of free cpu' do
    cluster = build(:cluster, cpu_total: 10.5, cpu_used: 7)
    expect(cluster.cpu_free).to eq 3.5
  end

  it 'returns the amount of free memory' do
    cluster = build(:cluster, memory_total: 100.5, memory_used: 70)
    expect(cluster.memory_free).to eq 30.5
  end
end
