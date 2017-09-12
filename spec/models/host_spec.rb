require 'rails_helper'

RSpec.describe Host, type: :model do
  let(:vmware_instance_cpu) { ENV["vmware_instance_cpu"].to_f }
  let(:vmware_instance_memory) { ENV["vmware_instance_memory"].to_f }
  let(:vmware_instance_disk) { ENV["vmware_instance_disk"].to_f }

  it 'has a valid factory' do
    expect(build(:host)).to be_valid
  end

  it 'is invalid with no name' do
    host = build(:host, name: nil)
    host.valid?
    expect(host.errors[:name]).to include("can't be blank")
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

  it 'is invalid with negative disk_total' do
    host = build(:host, disk_total: -1)
    host.valid?
    expect(host.errors[:disk_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative disk_used' do
    host = build(:host, disk_used: -1)
    host.valid?
    expect(host.errors[:disk_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative physical_cores' do
    host = build(:host, physical_cores: -1)
    host.valid?
    expect(host.errors[:physical_cores]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative virtual_cores' do
    host = build(:host, virtual_cores: -1)
    host.valid?
    expect(host.errors[:virtual_cores]).to include("must be greater than or equal to 0")
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

  it 'is invalid if disk_used is greater than disk_total' do
    host = build(:host, disk_total: 10, disk_used: 11)
    host.valid?
    expect(host.errors[:disk_used]).to include("must be less than or equal to 10.0")
  end

  it 'returns the amount of free cpu' do
    host = build(:host, cpu_total: 10.5, cpu_used: 7)
    expect(host.cpu_free).to eq 3.5
  end

  it 'returns the amount of free memory' do
    host = build(:host, memory_total: 100.5, memory_used: 70)
    expect(host.memory_free).to eq 30.5
  end

  it 'returns the amount of free disk' do
    host = build(:host, disk_total: 100.5, disk_used: 70)
    expect(host.disk_free).to eq 30.5
  end

  it 'returns the ratio of physical_cores to virtual_cores' do
    host = build(:host, physical_cores: 16, virtual_cores: 32)
    expect(host.ratio_cores).to eq 2
  end

  context "with instances based on memory" do
    it 'returns the total possible amount of instances' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(host.instances_total).to eq 20
    end

    it 'returns the amount of used instances' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(host.instances_used).to eq 8
    end

    it 'returns the amount of free instances' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(host.instances_free).to eq 12
    end

    it 'returns true for using instances from memory' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*7)
      expect(host.instances_from_memory?).to be true
    end
  end

  context "with instances based on memory" do
    it 'returns the total possible amount of instances' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(host.instances_total).to eq 25
    end

    it 'returns the amount of used instances' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(host.instances_used).to eq 20
    end

    it 'returns the amount of free instances' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(host.instances_free).to eq 5
    end

    it 'returns false for using instances from memory' do
      host = build(:host, memory_total: vmware_instance_memory*20,
                   disk_total: vmware_instance_disk*25,
                   memory_used: vmware_instance_memory*8,
                   disk_used: vmware_instance_disk*20)
      expect(host.instances_from_memory?).to be false
    end
  end
end
