require 'rails_helper'

RSpec.describe Cluster, type: :model do
  include_context "env"

  it 'has a valid factory' do
    expect(build(:cluster)).to be_valid
  end

  it 'is invalid with no name' do
    cluster = build(:cluster, name: nil)
    cluster.valid?
    expect(cluster.errors[:name]).to include("can't be blank")
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

  it 'is invalid with negative disk_total' do
    cluster = build(:cluster, disk_total: -1)
    cluster.valid?
    expect(cluster.errors[:disk_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative disk_used' do
    cluster = build(:cluster, disk_used: -1)
    cluster.valid?
    expect(cluster.errors[:disk_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative physical_cores' do
    cluster = build(:cluster, physical_cores: -1)
    cluster.valid?
    expect(cluster.errors[:physical_cores]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative virtual_cores' do
    cluster = build(:cluster, virtual_cores: -1)
    cluster.valid?
    expect(cluster.errors[:virtual_cores]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative hosts_total' do
    cluster = build(:cluster, hosts_total: -1)
    cluster.valid?
    expect(cluster.errors[:hosts_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative hosts_active' do
    cluster = build(:cluster, hosts_active: -1)
    cluster.valid?
    expect(cluster.errors[:hosts_active]).to include("must be greater than or equal to 0")
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

  it 'is invalid if disk_used is greater than disk_total' do
    cluster = build(:cluster, disk_total: 10, disk_used: 11)
    cluster.valid?
    expect(cluster.errors[:disk_used]).to include("must be less than or equal to 10.0")
  end

  it 'is invalid if hosts_active is greater than hosts_total' do
    cluster = build(:cluster, hosts_total: 10, hosts_active: 11)
    cluster.valid?
    expect(cluster.errors[:hosts_active]).to include("must be less than or equal to 10")
  end

  it 'returns the amount of free cpu' do
    cluster = build(:cluster, cpu_total: 10.5, cpu_used: 7)
    expect(cluster.cpu_free).to eq 3.5
  end

  it 'returns the amount of free memory' do
    cluster = build(:cluster, memory_total: 100.5, memory_used: 70)
    expect(cluster.memory_free).to eq 30.5
  end

  it 'returns the amount of free disk' do
    cluster = build(:cluster, disk_total: 100.5, disk_used: 70)
    expect(cluster.disk_free).to eq 30.5
  end

  it 'returns the ratio of physical_cores to virtual_cores' do
    cluster = build(:cluster, physical_cores: 16, virtual_cores: 32)
    expect(cluster.ratio_cores).to eq 2
  end

  context "with instances based on memory" do
    it 'returns the total possible amount of instances' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(cluster.instances_total).to eq 20
    end

    it 'returns the amount of used instances' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(cluster.instances_used).to eq 8
    end

    it 'returns the amount of free instances' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(cluster.instances_free).to eq 12
    end

    it 'returns true for using instances from memory' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(cluster.instances_from_memory?).to be true
    end
  end

  context "with instances based on memory" do
    it 'returns the total possible amount of instances' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(cluster.instances_total).to eq 25
    end

    it 'returns the amount of used instances' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(cluster.instances_used).to eq 20
    end

    it 'returns the amount of free instances' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(cluster.instances_free).to eq 5
    end

    it 'returns false for using instances from memory' do
      cluster = build(:cluster, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(cluster.instances_from_memory?).to be false
    end
  end
end
