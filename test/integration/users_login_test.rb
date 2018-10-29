require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael) # users corresponds to the fixture file name users.yaml
  end
  
  test 'log in with invalid info' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: {email: '', password: ''} }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test 'log in with valid info' do
    get login_path
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    assert_redirected_to @user # checks the right redirect target
    follow_redirect! # actually visit the target page
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0 # verifies that the login link disappears
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end
end
