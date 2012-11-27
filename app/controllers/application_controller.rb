class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :load_fav_projekts
  
  def load_fav_projekts
    @my_fav_projekts = Projekt.all
  end
end
