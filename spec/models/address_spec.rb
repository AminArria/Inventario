require 'rails_helper'

RSpec.describe Address, type: :model do
  it 'has a valid factory' do
    expect(build(:address)).to be_valid
  end

  it 'is invalid without an api_id' do
    address = build(:address, api_id: nil)
    address.valid?
    expect(address.errors[:api_id]).to include("can't be blank")
  end

  it 'is invalid without an ip' do
    address = build(:address, ip: nil)
    address.valid?
    expect(address.errors[:ip]).to include("can't be blank")
  end

  it 'is invalid without a subnet' do
    address = build(:address, subnet: nil)
    address.valid?
    expect(address.errors[:subnet]).to include("must exist")
  end
  it 'is created by default with an inactive status' do
    address = create(:address)
    expect(address.active).to be false
  end
end
