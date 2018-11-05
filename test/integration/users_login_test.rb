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
  
  test 'log in with valid info followed by logout' do
    get login_path
    post login_path, params: {session: {email: @user.email, password: 'password'}}
    assert is_logged_in?
    assert_redirected_to @user # checks the right redirect target
    follow_redirect! # actually visit the target page
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0 # verifies that the login link disappears
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path # Simulate a user clicking logut in a second window
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end
  
  test 'log in with remembering' do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end
  
  test 'log in without remembering' do
    # log in to set the cookie
    log_in_as(@user, remember_me: '1')
    # log in again & verify cookie is deleted
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
