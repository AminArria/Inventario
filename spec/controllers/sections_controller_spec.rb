require 'rails_helper'

RSpec.describe SectionsController, type: :controller do

  describe "GET #index" do
    it "returns a success response" do
      section = create(:section)
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      section = create(:section)
      get :show, params: {id: section.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      section = create(:section)
      get :edit, params: {id: section.to_param}
      expect(response).to be_success
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested section" do
        section = create(:section)
        new_section = build(:section)
        put :update, params: {id: section.to_param, section: new_section.attributes}
        section.reload
        expect(section.api_id).to eq new_section.api_id
        expect(section.name).to eq new_section.name
        expect(section.description).to eq new_section.description
      end

      it "redirects to the section" do
        section = create(:section)
        put :update, params: {id: section.to_param, section: attributes_for(:section)}
        expect(response).to redirect_to(section)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        section = create(:section)
        put :update, params: {id: section.to_param, section: attributes_for(:section, api_id: nil)}
        expect(response).to be_success
      end
    end
  end

end
