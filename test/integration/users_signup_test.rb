require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "for invalid user signup" do
    get signup_path
    assert_no_difference "User.count" do
    post users_path, params: { user: { name:  "  ", email: "user@invalid",
    password: "foo", password_confirmation: "bar" } }
    assert_template "users/new"
    end
  end

  test "for valid user signup with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "Test", email: "user@valid.co",
      password: "foobar", password_confirmation: "foobar" } }
      follow_redirect!
      # assert_template "users/show/"
      # assert is_logged_in?
    end
  end
end
