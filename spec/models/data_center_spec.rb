require 'rails_helper'

RSpec.describe DataCenter, type: :model do
  it 'has a valid factory' do
    expect(build(:data_center)).to be_valid
  end
end
