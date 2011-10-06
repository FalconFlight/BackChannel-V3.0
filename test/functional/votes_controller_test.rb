require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  fixtures :posts
  fixtures :users

  test "user cannot vote for his own posts" do
    #$current_user = users(:one)
    post :new, :userid_from_page => users(:one).id, :postid_from_page => posts(:one).id
    assert_redirected_to posts_path
    assert_equal 'Cannot Vote for your own posts!', flash[:error]
  end

  test "cannot vote for a post twice" do
    post :new, :userid_from_page => users(:two).id, :postid_from_page => posts(:one).id
    assert_redirected_to posts_path
    assert_equal "Vote already exists!", flash[:error]
  end

  test "user cannot vote for his own reply" do
    post :new, :userid_from_page => users(:two).id, :postid_from_page => posts(:two).id
    assert_redirected_to posts_path
    assert_equal "Cannot Vote for your own posts!", flash[:error]
  end

  test "cannot vote for a reply twice" do
    post :new, :userid_from_page => users(:three).id, :postid_from_page => posts(:two).id
    assert_redirected_to posts_path
    assert_equal "Vote already exists!", flash[:error]
  end

end
