require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
  end
  test "for unsuccessful user edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name:  "  ", email: "user@invalid",
    password: "foo", password_confirmation: "bar" } }
    assert_template "users/edit"
  end

  test "for successful user edit" do
    name = "Test1"
    email = "user@valid.com"
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    # assert_template "users/edit"
    patch user_path(@user), params: { user: { name: name, email: email,
    password: "", password_confirmation: "" } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end
end
