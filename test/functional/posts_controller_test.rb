require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :users

  test "empty post must not be saved" do
    post :create, post: { :content => ""}
    assert_equal "Content cannot be empty!", flash[:error]
  end


end
