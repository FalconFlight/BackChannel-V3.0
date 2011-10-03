module SessionsHelper
include UsersHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user #creates a var current_user to be used throughout the session
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    flash[:notice] = "Please Sign in to access this page."
    redirect_to signin_path
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def current_user?(user)
    user == current_user
  end


  def current_user=(user)
    @current_user = user
  end

  def current_user
    if(!@current_user.nil?)
      @current_user 
    elsif(remember_token[0] ==-1) 
      @current_user = create_guest_user
    else
      user_from_remember_token
    end
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
