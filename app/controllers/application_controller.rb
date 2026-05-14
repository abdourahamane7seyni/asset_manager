class ApplicationController < ActionController::Base
  layout :choose_layout

  private

  def choose_layout
    devise_controller? ? 'login' : 'application'
  end
end
