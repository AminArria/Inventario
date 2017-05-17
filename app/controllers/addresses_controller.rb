class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :set_subnet, only: [:index, :new, :create]

  # GET /addresses
  def index
    @addresses = @subnet.addresses
  end

  # GET /addresses/1
  def show
  end

  # GET /subnet/:subnet_id/addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  # POST /subnet/:subnet_id/addresses
  def create
    @address = Address.new(address_params)
    @address.subnet = @subnet

    if @address.save
      redirect_to @address, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /addresses/1
  def update
    if @address.update(address_params)
      redirect_to @address, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /addresses/1
  def destroy
    @address.destroy

    redirect_to subnet_addresses_path(@address.subnet), notice: 'Address was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    def set_subnet
      @subnet = Subnet.find(params[:subnet_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:api_id, :ip, :subnet_id, :active)
    end
end
