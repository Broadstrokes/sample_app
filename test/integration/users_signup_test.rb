require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end
  
  test 'invald signup information' do
    get signup_path
    assert_select 'form[action="/signup"]'

    assert_no_difference 'User.count' do
      post signup_path, params: {
      user: {
        name: '',
        email: 'user@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      }
    }
    end

    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  
  test 'successful signup with account activation' do
    get signup_path
    assert_select 'form[action="/signup"]'
    
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'Pink Panther',
          email: 'panther@gmail.com',
          password: 'foobar',
          password_confirmation: 'foobar'
        }
      }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    # Try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?
    
    # Invalid activation token
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    
    # Valid activation token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    
    # This simply arranges to follow the redirect after submission,
    # resulting in a rendering of the 'users/show' template
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_not flash.empty?
    assert_select 'div.alert-success'
  end
end
