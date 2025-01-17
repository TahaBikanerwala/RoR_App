module SessionsHelper
  # logs in given user by creating a session
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns current user if any
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # returns true if user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  def log_out
    forget_helper(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # remembers a user in a persistent session
  def remember_helper(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_helper(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  # Stores the URL trying to be accessed
  def store_location
    session[:forwarding_url] = request.original_url if request.get? || request.head?
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
