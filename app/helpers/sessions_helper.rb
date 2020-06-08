module SessionsHelper
  # logs in the given user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current logged-in user (if any).
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    end
  end

  # Forgets a persistent session.
  def forget
    cookies.delete(:user_id)
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !!current_user
  end

  # Logs out the current user.
  def log_out
    forget
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
