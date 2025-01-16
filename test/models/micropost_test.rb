require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:test)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "Micropost should be valid" do
    assert @micropost.valid?
  end

  test "User id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "Content should not be empty" do
    @micropost.content = "  "
    assert_not @micropost.valid?
  end

  test "Content should not be more than 140 chars" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end

  test "post order should be recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end
end
