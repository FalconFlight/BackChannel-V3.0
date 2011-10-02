module PostsHelper


  def display_parent(p)
    if p.parent==-1
     "This is a post not a reply"
    elsif p.parent.nil?
     "It is nil"
    else
      p.parent.to_s
    end
  end

end
