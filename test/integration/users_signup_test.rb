require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
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
  
  
  test 'successful signup' do
    get signup_path
    assert_select 'form[action="/signup"]'
    
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          name: 'Pink Panther',
          email: 'panther@gmail.com',
          password: 'foobar',
          password_confirmation: 'foobar'
        }
      }
    end
    # This simply arranges to follow the redirect after submission,
    # resulting in a rendering of the 'users/show' template
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert-success'
    
  end
end
