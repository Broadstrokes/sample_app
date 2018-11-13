require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  
  # The test checks for the correct behavior 
  # by verifying that the edit template is rendered after 
  # getting the edit page and re-rendered upon submission 
  # of invalid information
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: '',
        email: 'foo@invald',
        password: 'foo',
        password_confirmation: 'bar'
      }
    }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors'
  end
  
  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = 'foo@bar.com'
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: '', 
        password_confirmation: ''
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
  # simple test for friendly forwarding just by reversing 
  # the order of logging in and visiting the edit page
  # It tries to visit the edit page, then logs in, and then 
  # checks that the user is redirected to the edit page 
  # instead of the default profile page
  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: '',
        password_confirmation: ''
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
    assert_equal session[:forwarding_url], nil
  end
  
end

