class PostsController < ApplicationController

  def index
    
  end


  def new
    @title = "New Post"
    @post = Post.new
    @parent_id = -1
  end

  def newreply
    @title = "New Reply"
    @post = Post.new
    @parent_id = params[:parentid]
    render 'new'
  end

  def create
    @post = Post.new
    @post = current_user.posts.build(params[:post])
    @post.parent = params[:parentid]
  
    if(@post.parent == -1)
      @post.weight = Post.find_all_by_parent(-1).count
    else
      @post.weight = 0
    end

    if @post.save
      flash[:success] = "Successfully Posted!"
      redirect_to posts_path
    else
      flash[:error] = "Unsuccessful attempt. Try Again."
      @title = "Submit Post/Reply"
      render 'new'
    end
  end


end
