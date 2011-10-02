module PostsHelper


  def display_parent(p)
    if p.parent.nil?
     "This is a post not a reply"
    else
      p.parent.to_s
    end 
  end

end
