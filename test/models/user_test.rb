require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: 'Test user',
      email: 'testuser@gmail.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    )
  end
  
  test 'should be valid' do
    assert @user.valid?
  end
  
  test 'name should be present' do
    @user.name = '    '
    assert_not @user.valid?
  end
  
  
  test 'email should be present' do
    @user.email = '    '
    assert_not @user.valid?
  end
  
  test 'name should not be longer than 50 character' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end
  
  test 'email should not be longer than 255 characters' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end
  
  test 'email validation should accept valid email' do 
    valid_addresses = %w[
      user@example.com 
      USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp 
      alice+bob@baz.cn
    ]
    
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  test 'email validation should reject invalid email' do
    invalid_addresses = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
      foo@bar..com
    ]
  
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end
  
  test 'email should be unique' do 
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase  # to test same email with uppercase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test 'email should be saved as lower-case' do
    mixed_case_email = 'Foo@ExaMple.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end
  
  test 'password should have minimum length' do
    @user.password = @user.password_confirmation= 'a' * 5
    assert_not @user.valid?
  end
  
  test 'authenticated? should return false for a user with nil digest' do
    # @user defined in the setup method does not have a remember_digest 
    assert_not @user.authenticated?(:remember, '') # it doesn't matter what the value of remember_token is
  end
  
  test 'associated microposts should be destroyed' do
    # create 1 post by user, destroy that user, total Micropost count should
    # go down by 1
    @user.save
    @user.microposts.create!(content: 'Lorem ipsumussss')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end
