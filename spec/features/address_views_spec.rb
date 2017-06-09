require 'rails_helper'

feature "Network" do
  background do
    @section = create(:section)
    @subnet = create(:subnet, section: @section, mask: 30)
    @address = create(:address, subnet: @subnet, active: true)
  end



  scenario "can see all addresses belonging to a subnet" do
    visit sections_path

    find(".fa-list").find(:xpath, "..").click
    find(".fa-list").find(:xpath, "..").click

    expect(page).to have_content @address.ip
    expect(page).to have_content "Si"
  end
end