class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :load_fav_projekts
  
  def load_fav_projekts
    @my_fav_projekts = Projekt.all

    ActionMailer::Base.default_url_options = {:host => request.host_with_port}
  end
end
