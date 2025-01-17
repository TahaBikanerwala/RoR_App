require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "Home | Ruby on Rails App"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | Ruby on Rails App"
  end

  test "should get help" do
    get help_url
    assert_response :success
    assert_select "title", "Help | Ruby on Rails App"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | Ruby on Rails App"
  end
end
