class VotesController < ApplicationController

  def new
    @post = Post.find(params[:postid_from_page]) # post to be voted

    if(@post.nil?)
      flash[:error] = "Cannot vote for this post!"
      redirect_to posts_path and return
    end

    # check if vote already exists in table
    local_vote = Vote.find_by_user_id_and_post_id(params[:userid_from_page], params[:postid_from_page])

    if (!local_vote.nil?)
      flash[:error] = "Vote already exists!"
      redirect_to posts_path and return
    end

     # user cannot vote for his own posts
    if @post.user_id.to_i == params[:userid_from_page].to_i
      flash[:error] = "Cannot Vote for your own posts!"
    else
      # Update the weight of the post
      @post.update_attribute :weight, @post.weight+1

      @vote = Vote.new(:user_id => params[:userid_from_page], 
                       :post_id => params[:postid_from_page] )

      @author = User.find(@post.user_id)

      if @vote.save
        flash.now[:info] = "Vote Saved!"
        @author.update_attribute :total_votes, @author.total_votes+1
      else
        flash[:error] = "Could not save Vote."
      end
    end

    redirect_to posts_path and return
  end

end
