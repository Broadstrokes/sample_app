require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar' # checks for an img tag with class gravatar inside a top-level heading tag (h1)
    # if all we care about is that the number of microposts appears
    # somewhere on the page, we can look for a match as follows
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    assert_select 'div.pagination', count: 1 # test that will_paginate appears only once
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
