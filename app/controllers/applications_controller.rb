class ApplicationsController < ApplicationController

  def new
  end

  def create
    pet_ids_applied = params.select {|k,v| v == "1"}.keys
    application = Application.new(application_params)
    if application.save
      print_successful_flash(pet_ids_applied)
      remove_pets_from_favorites(application, pet_ids_applied)
      redirect_to "/favorite"
    else
      flash.now[:notice] = "You need to fill out all fields"
      render :new
    end
  end

  def print_successful_flash(pet_ids_applied)
    pet_names = pet_ids_applied.map {|pet_id| Pet.find(pet_id).name}
    flash[:notice] = "Your application has been processed for #{pet_names.join(", ")}"
  end

  def remove_pets_from_favorites(application, pet_ids_applied)
    pet_ids_applied.each do |pet_id|
      favorite.remove(pet_id)
      PetApplication.create(  pet_id: Pet.find(pet_id).id,
                              application_id: application.id)
    end
  end

  def show
    @application = Application.find(application_params[:application_id])
  end

private

  def application_params
    params.permit(:application_id, :name, :address, :city, :state, :zip, :phone_number, :description, :pets)
  end
end
