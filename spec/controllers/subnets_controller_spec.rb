require 'rails_helper'

RSpec.describe SubnetsController, type: :controller do

  describe "GET #index" do
    it "returns a success response" do
      section = create(:section)
      get :index, params: {section_id: section.id}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      subnet = create(:subnet)
      get :show, params: {id: subnet.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      section = create(:section)
      get :new, params: {section_id: section.id}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      subnet = create(:subnet)
      get :edit, params: {id: subnet.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Subnet" do
        subnet = build(:subnet)
        expect {
          post :create, params: {section_id: subnet.section_id, subnet: subnet.attributes}
        }.to change(Subnet, :count).by(1)
      end

      it "redirects to the created subnet" do
        subnet = build(:subnet)
        post :create, params: {section_id: subnet.section_id, subnet: subnet.attributes}
        expect(response).to redirect_to(Subnet.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        subnet = build(:subnet, api_id: nil)
        post :create, params: {section_id: subnet.section_id, subnet: subnet.attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested subnet" do
        subnet = create(:subnet)
        new_subnet = build(:subnet)
        put :update, params: {id: subnet.to_param, subnet: new_subnet.attributes}
        subnet.reload

        expect(subnet.api_id).to eq new_subnet.api_id
        expect(subnet.base).to eq new_subnet.base
        expect(subnet.mask).to eq new_subnet.mask
        expect(subnet.description).to eq new_subnet.description
        expect(subnet.section).to eq new_subnet.section
      end

      it "redirects to the subnet" do
        subnet = create(:subnet)
        put :update, params: {id: subnet.to_param, subnet: attributes_for(:subnet)}
        expect(response).to redirect_to(subnet)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        subnet = create(:subnet)
        put :update, params: {id: subnet.to_param, subnet: attributes_for(:subnet, api_id: nil)}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested subnet" do
      subnet = create(:subnet)
      expect {
        delete :destroy, params: {id: subnet.to_param}
      }.to change(Subnet, :count).by(-1)
    end

    it "redirects to the subnets list" do
      subnet = create(:subnet)
      delete :destroy, params: {id: subnet.to_param}
      expect(response).to redirect_to(section_subnets_path(subnet.section))
    end
  end

end
