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
end
