require 'test_helper'
require_relative '../../app/helpers/sessions_helper'


class UsersControllerTest < ActionController::TestCase
  include SessionsHelper

  fixtures :posts
  fixtures :users
  setup do
    @user = users(:one)
    @user.encrypted_password = "aaa"
    @user.salt = "yyy"
    @user.account_type = "admin"
  end


  test "should display Manage accounts when logged in as any admin" do
    current_user= @user
    get :index
    assert_response :success
    assert_equal 'This is privileged information to be viewed by Admin only!', flash[:info]
  end

  test "should " do
    current_user= @user
    get :index
    assert_response :success
    assert_equal 'This is privileged information to be viewed by Admin only!', flash[:info]
  end


 test "password must be encrypted" do
   user = User.new
   user.name = "User1"
   user.email = "user1@a.com"
   user.password = "aaa"
   user.save
   assert_not_equal(user.encrypted_password, user.password)
 end


end
