class SessionsController < ApplicationController

  def index
    render 'index'
  end

  def new
    @title = "Sign in"
  end


  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    else
      sign_in user
      redirect_back_or posts_path # user_path(user)
    end
  end


  def destroy
    sign_out
    redirect_to root_path
  end

end
