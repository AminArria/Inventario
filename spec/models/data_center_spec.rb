require 'rails_helper'

RSpec.describe DataCenter, type: :model do
  it 'has a valid factory' do
    expect(build(:data_center)).to be_valid
  end

  it 'is invalid with no name' do
    data_center = build(:data_center, name: nil)
    data_center.valid?
    expect(data_center.errors[:name]).to include("can't be blank")
  end

  context 'usage methods' do
    before :each do
      @data_center = create(:data_center)
      create(:cluster, data_center: @data_center,
        cpu_total: 10.5, cpu_used: 7, memory_total: 100.5, memory_used: 70)
      create(:cluster, data_center: @data_center,
        cpu_total: 10.5, cpu_used: 7, memory_total: 100.5, memory_used: 70)
    end

    it 'returns the amount of total cpu' do
      expect(@data_center.cpu_total).to eq 21
    end

    it 'returns the amount of total memory' do
      expect(@data_center.memory_total).to eq 201
    end

    it 'returns the amount of used cpu' do
      expect(@data_center.cpu_used).to eq 14
    end

    it 'returns the amount of used memory' do
      expect(@data_center.memory_used).to eq 140
    end

    it 'returns the amount of free cpu' do
      expect(@data_center.cpu_free).to eq 7
    end

    it 'returns the amount of free memory' do
      expect(@data_center.memory_free).to eq 61
    end
  end

  context "using more cpu than memory" do
    before(:each) do
      c = create(:cluster,
             cpu_total: ENV["vmware_instance_cpu"].to_i*2,
             cpu_used: ENV["vmware_instance_cpu"].to_i,
             memory_total: ENV["vmware_instance_memory"].to_i*5,
             memory_used: 0)
      @data_center = c.data_center
    end

    it "returns total instances" do
      expect(@data_center.instances_total).to eq 2
    end

    it "returns used instances" do
      expect(@data_center.instances_used).to eq 1
    end
  end

  context "using more memory than cpu" do
    before(:each) do
      c = create(:cluster,
             cpu_total: ENV["vmware_instance_cpu"].to_i*5,
             cpu_used: 0,
             memory_total: ENV["vmware_instance_memory"].to_i*2,
             memory_used: ENV["vmware_instance_memory"].to_i)
      @data_center = c.data_center
    end

    it "returns total instances" do
      expect(@data_center.instances_total).to eq 2
    end

    it "returns used instances" do
      expect(@data_center.instances_used).to eq 1
    end
  end
end
