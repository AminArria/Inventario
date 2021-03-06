class SubnetsController < ApplicationController
  before_action :set_subnet, only: [:show, :edit, :update, :destroy]
  before_action :set_section, only: [:index, :new, :create]

  # GET /sections/:section_id/subnets
  def index
    @subnets = @section.subnets
  end

  # GET /subnets/1
  def show
  end

  # GET /sections/:section_id/subnets/new
  def new
    @subnet = Subnet.new
  end

  # GET /subnets/1/edit
  def edit
  end

  # POST /sections/:section_id/subnets
  def create
    @subnet = Subnet.new(subnet_params)

    if @subnet.save
      redirect_to @subnet, notice: 'Subnet was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /subnets/1
  def update
    if @subnet.update(subnet_params)
      redirect_to @subnet, notice: 'Subnet was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /subnets/1
  def destroy
    @subnet.destroy

    redirect_to section_subnets_path(@subnet.section), notice: 'Subnet was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subnet
      @subnet = Subnet.find(params[:id])
    end

    def set_section
      @section = Section.find(params[:section_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subnet_params
      params.require(:subnet).permit(:api_id, :base, :mask, :section_id, :description)
    end
end
