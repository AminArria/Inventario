require 'rails_helper'

RSpec.describe AddressesController, type: :controller do

  describe "GET #index" do
    it "returns a success response" do
      address = create(:address)
      get :index, params: {subnet_id: address.subnet_id}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      address = create(:address)
      get :show, params: {id: address.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      address = create(:address)
      get :new, params: {subnet_id: address.subnet_id}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      address = create(:address)
      get :edit, params: {id: address.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Address" do
        address = build(:address)
        expect {
          post :create, params: {subnet_id: address.subnet_id, address: address.attributes}
        }.to change(Address, :count).by(1)
      end

      it "redirects to the created address" do
        address = build(:address)
        post :create, params: {subnet_id: address.subnet_id, address: address.attributes}
        expect(response).to redirect_to(Address.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        address = build(:address,api_id: nil)
        post :create, params: {subnet_id: address.subnet_id, address: address.attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested address" do
        address = create(:address)
        new_address = build(:address)
        put :update, params: {id: address.to_param, address: new_address.attributes}
        address.reload

        expect(address.api_id).to eq new_address.api_id
        expect(address.ip).to eq new_address.ip
        expect(address.subnet_id).to eq new_address.subnet_id
        expect(address.active).to eq new_address.active
      end

      it "redirects to the address" do
        address = create(:address)
        put :update, params: {id: address.to_param, address: attributes_for(:address)}
        expect(response).to redirect_to(address)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        address = create(:address)
        put :update, params: {id: address.to_param, address: attributes_for(:address, api_id: nil)}
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested address" do
      address = create(:address)
      expect {
        delete :destroy, params: {subnet_id: address.subnet_id, id: address.to_param}
      }.to change(Address, :count).by(-1)
    end

    it "redirects to the addresses list" do
      address = create(:address)
      delete :destroy, params: {subnet_id: address.subnet_id, id: address.to_param}
      expect(response).to redirect_to(subnet_addresses_path(address.subnet))
    end
  end

end
