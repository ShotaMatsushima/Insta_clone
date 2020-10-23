require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user=User.new(name: "松嶋翔太", user_name: "しょうたん", email: "test@gmail.com", 
    password: "password", password_confirmation: "password")
  end
  
  test "shoud be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name="    "
    assert_not @user.valid?
  end
  
  test "user_name should be present" do
    @user.user_name="    "
    assert_not @user.valid?
  end
  
  test "email should be present" do
    @user.email="    "
    assert_not @user.valid?
  end
  
  test "password should be present" do
    @user.password=@user.password_confirmation=" "*6
    assert_not @user.valid?
  end
    
    
  
  test "name should not be too long" do 
    @user.name="a"*51
    assert_not @user.valid?
  end
  
  test "user_name should not be too long" do 
    @user.user_name="a"*51
    assert_not @user.valid?
  end
    
  test "email should not be too long" do 
    @user.name="a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "password should be 6 more" do
    @user.password=@user.password_confirmation="a"*5
    assert_not @user.valid?
  end
  
  test "user_name and email addresses should be unique" do
    duplicate_user=@user.dup
    duplicate_user.email=@user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  
end