class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :favorite, :pet_id_lookup

  def favorite
    @favorite ||= Favorite.new(session[:favorite])
  end

  def pet_id_lookup(pet_id)
    Pet.find(pet_id)
  end

end
