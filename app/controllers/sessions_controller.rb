class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      log_in(user)
      return redirect_back_or(user)
    end
    flash[:danger] = "Invalid email/password combination"
    redirect_to login_url
  end

  def destroy
    log_out if logged_in?
    flash[:danger] = "Logged out successfully"
    redirect_to root_url
  end
end
