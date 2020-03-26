class FavoriteController < ApplicationController

  def update
    pet = Pet.find(params[:pet_id])
    flash[:notice] = "#{pet.name} has been added to your favorites list."
    redirect_to "/pets/#{params[:pet_id]}"
  end
end