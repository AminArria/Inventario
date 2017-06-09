require 'rails_helper'

feature "Section" do
  background do
    @section = create(:section)
    @subnet = create(:subnet, section: @section, mask: 30)
    @address = create(:address, subnet: @subnet, active: true)
  end

  scenario "can see all sections" do
    visit sections_path

    expect(page).to have_content @section.name
    expect(page).to have_content @section.description
  end

  scenario "can see section details" do
    visit sections_path

    find(".fa-search").find(:xpath, "..").click

    expect(page).to have_content @section.api_id
    expect(page).to have_content @section.name
    expect(page).to have_content @section.description
    expect(page).to have_content 2 # Total public IPs
    expect(page).to have_content 1 # Used public IPs
    expect(page).to have_content 1 # Free public IPs
    expect(page).to have_content "50,00%" # Public IPs used percentage
    expect(page).to have_content "50,00%" # Public IPs free percentage
  end
end
