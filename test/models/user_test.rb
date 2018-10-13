require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Test user', email: 'testuser@gmail.com')
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
end
