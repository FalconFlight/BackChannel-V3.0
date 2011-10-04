class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @all_users = User.all(:order => 'users.total_votes DESC')
  end


  def show
    @user  = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user  = User.new
    @title = "Sign Up"
    @acc_type = "regular"
    if(params[:user_type] == "guest")
      sign_in create_guest_user
      # save it in the cookie
      flash[:success] = "Welcome to BackChannel App!"
      redirect_to posts_path and return
    else
      render 'new'
    end
  end


  def create
    flash[:success] = ""

    if params[:user_type_admin] == "admin"
      @admin_user = User.new(params[:user])
      @admin_user.account_type = "admin"
      @admin_user.total_votes  = 0
      if @admin_user.save
        flash[:success] = "Successfully created Admin account."
      else
        flash[:error] = "Could not create Admin account"
      end      
      redirect_to users_path and return
    end

    flash[:success] += "Outside loop | "

    @user = User.new(params[:user])
    @user.total_votes = 0

    if params[:user_type_from_button] == "admin"
      @user.account_type = "admin"
    else
      @user.account_type = "regular"
    end

    if @user.save
      sign_in @user
      flash[:success] += "Welcome to BackChannel App!"
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


  def newadmin
    @user  = User.new
    @acc_type = "admin"
    @title = "Sign Up"
    render 'new'
  end

  def delete
    @user = User.find(params[:user_id])

    Post.find_all_by_user_id(@user.id).each do |post|
      # delete all entries in votes table with post_id = this
      votes = Vote.find_all_by_post_id(post.id)
      votes.each do |v|
        v.destroy
      end

      # destroy all replies to this post
      replies = Post.find_all_by_parent(post.id)

      replies.each do |r|
        # destroy all votes to this reply
        votes = Vote.find_all_by_post_id(r.id)
        votes.each do |v|
          v.destroy
        end
        r.destroy
      end

      post.destroy
    end

    if(@user.id == current_user.id) # then sign him out and delete user
      sign_out
      @user.destroy
      redirect_to signin_path and return
    end

    @user.destroy
    flash[:success] = "User (and all his votes/posts has been destroyed"
    redirect_to users_path
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
