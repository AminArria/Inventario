require 'rails_helper'

RSpec.describe DataCenter, type: :model do
  it 'has a valid factory' do
    expect(build(:data_center)).to be_valid
  end

  it 'is invalid with no name' do
    host = build(:host, name: nil)
    host.valid?
    expect(host.errors[:name]).to include("can't be blank")
  end
end
