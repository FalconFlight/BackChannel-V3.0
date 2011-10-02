class PostsController < ApplicationController
  attr_accessor :local_id


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
    @post = current_user.posts.build(params[:post])
#    @post.parent= params[:parentid]

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
