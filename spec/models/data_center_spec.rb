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
end
