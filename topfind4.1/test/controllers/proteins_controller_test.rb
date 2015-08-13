require File.expand_path("../../test_helper", __FILE__)

class ProteinsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  def test_index
     get(:index, {'query' => 'P39900'})
     
     assert_response :redirect, @response.body
  end
end
