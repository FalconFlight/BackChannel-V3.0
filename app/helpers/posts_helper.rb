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

end
