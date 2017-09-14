require 'rails_helper'

RSpec.describe DataCenter, type: :model do
  include_context 'env'

  it 'has a valid factory' do
    expect(build(:data_center)).to be_valid
  end

  it 'is invalid with no name' do
    data_center = build(:data_center, name: nil)
    data_center.valid?
    expect(data_center.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with negative disk_total' do
    data_center = build(:data_center, disk_total: -1)
    data_center.valid?
    expect(data_center.errors[:disk_total]).to include("must be greater than or equal to 0")
  end

  it 'is invalid with negative disk_used' do
    data_center = build(:data_center, disk_used: -1)
    data_center.valid?
    expect(data_center.errors[:disk_used]).to include("must be greater than or equal to 0")
  end

  it 'is invalid if disk_used is greater than disk_total' do
    data_center = build(:data_center, disk_total: 10, disk_used: 11)
    data_center.valid?
    expect(data_center.errors[:disk_used]).to include("must be less than or equal to 10.0")
  end

  it 'returns the amount of total cpu' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, cpu_total: 10)
    expect(data_center.cpu_total).to eq 10
  end

  it 'returns the amount of used cpu' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, cpu_total: 10, cpu_used: 7)
    expect(data_center.cpu_used).to eq 7
  end

  it 'returns the amount of free cpu' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, cpu_total: 10, cpu_used: 7)
    expect(data_center.cpu_free).to eq 3
  end

  it 'returns the amount of total memory' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, memory_total: 10)
    expect(data_center.memory_total).to eq 10
  end

  it 'returns the amount of used memory' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, memory_total: 10, memory_used: 7)
    expect(data_center.memory_used).to eq 7
  end

  it 'returns the amount of free memory' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, memory_total: 10, memory_used: 7)
    expect(data_center.memory_free).to eq 3
  end

  it 'returns the amount of free disk' do
    data_center = build(:data_center, disk_total: 100.5, disk_used: 70)
    expect(data_center.disk_free).to eq 30.5
  end

  it 'returns the amount of physical_cores' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, physical_cores: 16)
    expect(data_center.physical_cores).to eq 16
  end

  it 'returns the amount of virtual_cores' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, virtual_cores: 32)
    expect(data_center.virtual_cores).to eq 32
  end

  it 'returns the ratio of physical_cores to virtual_cores' do
    data_center = build(:data_center)
    create(:cluster, data_center: data_center, physical_cores: 16, virtual_cores: 32)
    expect(data_center.ratio_cores).to eq 2
  end

  context "with instances based on memory" do
    let!(:data_center) {
      create(:data_center,
             disk_total: vmware_instance_disk*25,
             disk_used: vmware_instance_disk*7)
    }

    let!(:cluster) {
      create(:cluster, data_center: data_center,
            memory_total: vmware_instance_memory*20,
            memory_used: vmware_instance_memory*8)
    }

    it 'returns the total possible amount of instances' do
      expect(data_center.instances_total).to eq 20
    end

    it 'returns the amount of used instances' do
      expect(data_center.instances_used).to eq 8
    end

    it 'returns the amount of free instances' do
      expect(data_center.instances_free).to eq 12
    end

    it 'returns true for using instances from memory' do
      expect(data_center.instances_from_memory?).to be true
    end
  end

  context "with instances based on memory" do
    let!(:data_center) {
      create(:data_center,
             disk_total: vmware_instance_disk*25,
             disk_used: vmware_instance_disk*20)
    }
    let!(:cluster) {
      create(:cluster, data_center: data_center,
            memory_total: vmware_instance_memory*20,
            memory_used: vmware_instance_memory*8)
    }

    it 'returns the total possible amount of instances' do
      expect(data_center.instances_total).to eq 25
    end

    it 'returns the amount of used instances' do
      expect(data_center.instances_used).to eq 20
    end

    it 'returns the amount of free instances' do
      expect(data_center.instances_free).to eq 5
    end

    it 'returns false for using instances from memory' do
      expect(data_center.instances_from_memory?).to be false
    end
  end
end
