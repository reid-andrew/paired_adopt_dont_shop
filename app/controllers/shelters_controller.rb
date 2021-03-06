class SheltersController < ApplicationController

  def index
    @shelters = Shelter.all
  end

  def new; end

  def create
    shelter = Shelter.create(shelter_params)
    if shelter.save
      redirect_to "/shelters/#{shelter.id}"
    else
      flash.now[:notice] = "You need to complete the #{missing_fields(shelter_params)} information"
      render :new
    end
  end

  def show
    @shelter = Shelter.find(params[:shelter_id])
  end

  def edit
    @shelter = Shelter.find(params[:shelter_id])
  end

  def update
    @shelter = Shelter.find(params[:shelter_id])
    if missing_fields(shelter_params).length > 0
      flash.now[:notice] = "You need to complete the #{missing_fields(shelter_params)} information"
      render :edit
    else
      @shelter.update(shelter_params)
      redirect_to "/shelters/#{@shelter.id}"
    end
  end

  def destroy
    shelter = Shelter.find(params[:shelter_id])
    shelter.pets.each do |pet|
      pet.pet_applications.destroy_all
      pet.destroy
     end
    shelter.reviews.destroy_all
    Shelter.destroy(params[:shelter_id])
    redirect_to "/shelters"
  end

  private

  def shelter_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
