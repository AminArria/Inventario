require 'rails_helper'

RSpec.describe Subnet, type: :model do
  it 'has a valid factory' do
    expect(build(:subnet)).to be_valid
  end

  it 'is invalid without an api_id' do
    subnet = build(:subnet, api_id: nil)
    subnet.valid?
    expect(subnet.errors[:api_id]).to include("can't be blank")
  end

  it 'is invalid without a base' do
    subnet = build(:subnet, base: nil)
    subnet.valid?
    expect(subnet.errors[:base]).to include("can't be blank")
  end

  it 'is invalid without a mask' do
    subnet = build(:subnet, mask: nil)
    subnet.valid?
    expect(subnet.errors[:mask]).to include("can't be blank")
  end

  it 'is invalid without a section' do
    subnet = build(:subnet, section: nil)
    subnet.valid?
    expect(subnet.errors[:section]).to include("must exist")
  end

  it 'is invalid if max_hosts is negative' do
    subnet = build(:subnet, max_hosts: -1)
    subnet.valid?
    expect(subnet.errors[:max_hosts]).to include("must be greater than or equal to 0")
  end

  it 'gives the amount of used hosts' do
    subnet = create(:subnet, mask: 30)
    2.times do
      create(:address, subnet: subnet, active: true)
    end
    expect(subnet.used_hosts).to eq 2
  end

  it 'gives the amount of free hosts' do
    subnet = create(:subnet, mask: 30)
    expect(subnet.free_hosts).to eq 2
  end

  it 'gives the percentage of used hosts' do
    subnet = create(:subnet, mask: 29)
    3.times do
      create(:address, subnet: subnet, active: true)
    end
    expect(subnet.used_percentage).to eq 50
  end

  it 'gives the percentage of free hosts' do
    subnet = create(:subnet, mask: 30)
    2.times do
      create(:address, subnet: subnet, active: true)
    end
    expect(subnet.free_percentage).to eq 0
  end

  it 'is classified as public' do
    subnet = create(:subnet, base: '8.8.8.0')
    expect(subnet.public).to be true
  end

  it 'is classified as private' do
    subnet = create(:subnet, base: '10.70.25.0')
    expect(subnet.public).to be false
  end

end
