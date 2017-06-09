require 'rails_helper'

feature "Dashboard" do
  background do
    @section = create(:section)
    @subnet_public = create(:subnet, section: @section, base: "10.70.1.0", mask: 30)
    @subnet_private = create(:subnet, section: @section, base: "8.8.8.0", mask: 30)
    create(:address, subnet: @subnet_public, active: true)
  end

  scenario "shows network details" do
    visit root_path

    # Checking public IPs
    expect(page).to have_content 1 # Public subnets total
    expect(page).to have_content 2 # Total public IPs
    expect(page).to have_content 1 # Used public IPs
    expect(page).to have_content 1 # Free public IPs
    expect(page).to have_content "50,00%" # Public IPs used percentage
    expect(page).to have_content "50,00%" # Public IPs free percentage

    # Checking private IPs
    expect(page).to have_content 1 # Private subnets total
    expect(page).to have_content 2 # Total private IPs
    expect(page).to have_content 0 # Used private IPs
    expect(page).to have_content 2 # Free private IPs
    expect(page).to have_content "0,00%" # Private IPs used percentage
    expect(page).to have_content "100,00%" # Private IPs free percentage
  end
end
