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
end
