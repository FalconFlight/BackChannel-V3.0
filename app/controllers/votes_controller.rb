class VotesController < ApplicationController

  def new
    @post = Post.find(params[:postid_from_page])

    # check if vote already exists in table
    local_vote = Vote.find_by_user_id_and_post_id(params[:userid_from_page], params[:postid_from_page])

    if (!local_vote.nil?)
      flash[:error] = "Vote already exists"
      redirect_to posts_path and return
    end


     # user cannot vote for his own posts
    if @post.user_id.to_i == params[:userid_from_page].to_i
      flash[:error] = "Cannot Vote for own posts" 
    else
      # Update the weight of the user
      if @post.update_attribute :weight, @post.weight+1
        flash[:success] = "Updated Weight | Actual:#{@post.user_id}, FromPage:#{params[:userid_from_page]}"
      else
        flash[:error] = "Failed to update weight"
      end  
    
      @vote = Vote.new(:user_id => params[:userid_from_page], 
                       :post_id => params[:postid_from_page] )
      if @vote.save
        flash[:success] += " | Saved Vote successfully"
      else
        flash[:error]+= " | Could not save Vote"
      end
    end

    redirect_to posts_path and return
  end

end
