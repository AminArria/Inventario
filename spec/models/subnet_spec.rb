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

  it 'is invalid if used_hosts exceed max_hosts' do
    subnet = build(:subnet, used_hosts: 2, max_hosts: 1)
    subnet.valid?
    expect(subnet.errors[:used_hosts]).to include("must be less than")
  end

  it 'is invalid if used_hosts is negative' do
    subnet = build(:subnet, used_hosts: -1)
    subnet.valid?
    expect(subnet.errors[:used_hosts]).to include("must be greater than or equal to 0")
  end

  it 'is invalid if max_hosts is negative' do
    subnet = build(:subnet, max_hosts: -1)
    subnet.valid?
    expect(subnet.errors[:used_hosts]).to include("must be greater than or equal to 0")
  end

  it 'gives the number of free hosts' do
    subnet = create(:subnet_hosts)
    expect(subnet.free_hosts).to eq 1
  end

  it 'gives the percentage of used hosts' do
    subnet = create(:subnet_hosts)
    expect(subnet.used_percentage).to eq (subnet.max_hosts / subnet.used_hosts * 100)
  end

  it 'gives the percentage of free hosts' do
    subnet = create(:subnet_hosts)
    expect(subnet.used_percentage).to eq (subnet.max_hosts / subnet.free_hosts * 100)
  end

end
