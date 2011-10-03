module UsersHelper

  def create_guest_user
      user = User.new
      user.id    = -1
      user.name  = "Guest User"
      user.email = "guest@guest.com"
      user.account_type  = "guest"
      user.encrypted_password = "dummyvalue"
      user.salt = "dummyvalue"
      return user
  end

end
