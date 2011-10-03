class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def show
    @user  = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user  = User.new
    @title = "Sign Up"

    if(params[:user_type] == "guest")
      #TODO construct dummy user with type guest
      sign_in create_guest_user
      # save it in the cookie
      flash[:success] = "Welcome to BackChannel App!"
      redirect_to posts_path and return
    else
      render 'new'
    end

  end

  def create
    @user = User.new(params[:user])

    if params[:user_type_from_button] == "admin"
      @user.account_type = "admin"
    else
      @user.account_type = "regular"
    end


    if @user.save
      sign_in @user
      flash[:success] = "Welcome to BackChannel App!"
      redirect_to posts_path 
    else
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit User"
  end

# Currently not implemented
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile Updated."
      redirect_to user_path(@user)
    else
      @title = "Edit User"
      render 'edit'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
