class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  #Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  #Confirms and admin user
  def allow_only_admins
    unless current_user.admin?
      flash[:danger] = "You are not authorized to access this page."
      redirect_to tickets_url
    end
  end
end
