require 'test_helper'

class FinalExamControllerTest < ActionDispatch::IntegrationTest
  test "should get finished_the_course" do
    get finished_path
    assert_response :success
  end

end
