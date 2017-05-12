require 'rails_helper'

RSpec.describe Section, type: :model do
  it 'has a valid factory' do
    expect(build(:section)).to be_valid
  end

  it 'is invalid without an api_id' do
    section = build(:section, api_id: nil)
    section.valid?
    expect(section.errors[:api_id]).to include("can't be blank")
  end

  it 'is invalid without a name' do
    section = build(:section, name: nil)
    section.valid?
    expect(section.errors[:name]).to include("can't be blank")
  end
end
