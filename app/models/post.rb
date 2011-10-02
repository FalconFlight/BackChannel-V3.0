class Post < ActiveRecord::Base
#  attr_accessor :content#, :parent, :user_id
  attr_accessible :content, :parent#, :user_id

  belongs_to :user

  validates :content, :presence => true, :length => { :within => 2..240 }

  validates :user_id, :presence => true

  def parent=(id)
    self.parent = id
  end


  default_scope :order => 'posts.created_at DESC'
end
