require 'rails_helper'

feature "Network" do
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

  scenario "can see all subnets belonging to a section" do
    visit sections_path

    find(".fa-list").find(:xpath, "..").click

    expect(page).to have_content @subnet.cidr
    expect(page).to have_content @subnet.description
  end

  scenario "can see subnet details" do
    visit section_subnets_path(@section)

    find(".fa-search").find(:xpath, "..").click

    expect(page).to have_content @subnet.api_id
    expect(page).to have_content @subnet.section.name
    expect(page).to have_content @subnet.base
    expect(page).to have_content @subnet.mask
    expect(page).to have_content @subnet.description
    expect(page).to have_content 2 # Total public IPs
    expect(page).to have_content 1 # Used public IPs
    expect(page).to have_content 1 # Free public IPs
    expect(page).to have_content "50,00%" # Public IPs used percentage
    expect(page).to have_content "50,00%" # Public IPs free percentage
  end

  scenario "can see all addresses belonging to a subnet" do
    visit sections_path

    find(".fa-list").find(:xpath, "..").click
    find(".fa-list").find(:xpath, "..").click

    expect(page).to have_content @address.ip
    expect(page).to have_content "Si"
  end
end