module PostsHelper


  def display_parent(p)
    if p.parent==-1
     "--"
    elsif p.parent.nil?
     "Some problem: It is nil"
    else
      p.parent.to_s
    end
  end

  def total_replies_authored(id, all_posts)
    #upper_limit = 1.0/0
    Post.find_all_by_user_id(id,:conditions => ["posts.parent >= ?",0]).count# - all_posts
  end

end
