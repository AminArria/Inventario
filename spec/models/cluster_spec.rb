require 'rails_helper'

RSpec.describe Cluster, type: :model do
  it 'has a valid factory' do
    expect(build(:cluster)).to be_valid
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
    expect(cluster.errors[:cpu_used]).to include("must be less than 10.0")
  end

  it 'is invalid if memory_used is greater than memory_total' do
    cluster = build(:cluster, memory_total: 10, memory_used: 11)
    cluster.valid?
    expect(cluster.errors[:memory_used]).to include("must be less than 10.0")
  end
end
