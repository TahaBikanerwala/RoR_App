require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    @new_test = users(:new_test)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end

class FollowTest < FollowingTest
  test "should follow a user the standard way" do
    assert_difference "@user.following.count", 1 do
     post relationships_path, params: { followed_id: @new_test.id }
    end
    assert_redirected_to @new_test
  end

  test "should follow a user the hotwire way" do
    assert_difference "@user.following.count", 1 do
     post relationships_path(format: :turbo_stream), params: { followed_id: @new_test.id }
    end
  end
end

class Unfollow < FollowingTest
  def setup
    super
    @user.follow(@new_test)
    @relationship = @user.active_relationships.find_by(followed_id: @new_test.id)
  end
end

class UnfollowTest < Unfollow
  test "should unfollow a user the standard way" do
    assert_difference "@user.following.count", -1 do
     delete relationship_path(@relationship)
    end
    assert_redirected_to @new_test
  end

  test "should unfollow a user the hotwire way" do
    assert_difference "@user.following.count", -1 do
     delete relationship_path(@relationship, format: :turbo_stream)
    end
  end
end
