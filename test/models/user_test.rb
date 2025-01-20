require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
    password: "Foobarbazz6!", password_confirmation: "Foobarbazz6!")
  end

  test "User should be valid" do
    assert @user.valid?
  end

  test "User should have a name" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "User should have an email" do
    @user.email =  "   "
    assert_not @user.valid?
  end

  test "Name should not be too long" do
    @user.name= "t"*21
    assert_not @user.valid?
  end

  test "Email should not be too long" do
    @user.name= "t"*256
    assert_not @user.valid?
  end

  test "Email validation should be accept valid emails" do
    valid_emails = %w[user@example.com USER@example.COM A_vA-lId@email.in.org
                      first.last@ya.jp alice445+jo3@sad.cji]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "Email valid should not accept invalid emails" do
    invalid_emails = %w[ur@e+com USER@example,COM A_vA-lIdemail.in.org
                      first.last@ya. alice445+jo3@sad_cji.co]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be valid"
    end
  end

  test "Email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "Password should be atleast 6 chars long" do
    @user.password= "t"*5
    @user.password_confirmation = "t"*5
    assert_not @user.valid?
  end

  test "authenticated? should return  false for user with nil digest" do
  assert_not @user.authenticated?(:remember, "")
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow unfolllow user" do
    test = users(:test)
    random_test = users(:random_test)
    assert_not test.following?(random_test)
    test.follow(random_test)
    assert test.following?(random_test)
    assert random_test.followers.include?(test)
    test.unfollow(random_test)
    assert_not test.following?(random_test)
  end

  test "feed should have the right posts" do
    test = users(:test)
    another_test =  users(:another_test)
    jack = users(:jack)
    # posts from followed user
    another_test.microposts.each do |post_following|
      assert test.feed.include?(post_following)
    end
    # posts of self
    test.microposts.each do |post_self|
      assert test.feed.include?(post_self)
    end
    # posts from unfollowed user
    jack.microposts.each do |post_unfollowed|
      assert_not test.feed.include?(post_unfollowed)
    end
  end
end
