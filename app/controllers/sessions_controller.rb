class SessionsController < ApplicationController

  def new
    redirect_to tickets_url if logged_in?
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
    flash[:success] = "Logged out successfully"
    redirect_to login_url
  end
end
