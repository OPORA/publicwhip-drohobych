require 'test_helper'

class PolicyPepoleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get policy_pepole_index_url
    assert_response :success
  end

end
