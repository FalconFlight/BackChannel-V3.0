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

  def delete
    @post = Post.find(params[:post_id])
    # delete all entries in votes table with post_id = this
    votes = Vote.find_all_by_post_id(@post.id)
    votes.each do |v|
      v.destroy
    end

    # destroy all replies to this post
    replies = Post.find_all_by_parent(@post.id)

    replies.each do |r|
      # destroy all votes to this reply
      votes = Vote.find_all_by_post_id(r.id)
      votes.each do |v|
        v.destroy
      end
      r.destroy
    end

    @post.destroy

    render 'index'
  end

  def show
    render 'index'
  end


  def search
    if params[:search_string].blank?
      flash[:error] = "Cannot have an empty Search Field!"
      redirect_to posts_path and return
    end
    @searched_from = params[:searched_from]

    if params[:search_type] == "user"
      search_str = params[:search_string].strip
      @author  = User.all( :conditions => ["users.name LIKE ?", search_str])[0]
      #@author = author_arr[0]
      #author_obj.each do |each_author|
      #  if each_author.name.casecmp(params[:search_type])
      #    @author = each_author
      #  end
      #end

      if(@author.nil?)
        @post_threads  = Array.new
        @reply_threads = Array.new
        render 'posts/searchresult' and return
      end

      @post_threads = Post.find_all_by_user_id_and_parent(@author.id, -1)

      post_thread_ids = Array.new
      @post_threads.each do |post|
        post_thread_ids << post.id
      end

      replies =  Post.find_all_by_user_id(@author.id, :conditions => ["posts.parent >= ?",1])
      @reply_threads = Array.new

      replies.each do |r|
        @reply_threads << r.parent
      end
      @reply_threads.uniq

      @reply_threads -= post_thread_ids
      @search_type = "user"
      @search_string = params[:search_string]

      render 'posts/searchresult' and return

    elsif params[:search_type] == "posts"
      search_str = params[:search_string].strip.downcase
      @post_threads  = Array.new
      @reply_threads = Array.new # contains only the post ids of reply threads

      Post.find_all_by_parent(-1).each do |each_post|
        if(each_post.content.downcase.include?(search_str))
          @post_threads << each_post
        end
      end

      Post.all(:conditions => ["posts.parent >= ?",1]).each do |each_reply|
        if(each_reply.content.downcase.include?(search_str))
          @reply_threads << each_reply.parent
        end
      end
      @reply_threads.uniq
      @search_type = "posts"
      @search_string = params[:search_string]

      render 'posts/searchresult' and return
    end

  end

end
