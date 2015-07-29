require File.expand_path("../../test_helper", __FILE__)

class EvidenceTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  
  def test_found_evidence
    found = Evidence.find(1)
    assert !found.nil?
  end
  
  def test_id
    found = Evidence.find(1)
    assert found.externalid == "TE1", "wrong id"
  end
  def test_fasterCSV
    found = Evidence.find(1)
    Evidence.generate_csv([1,2])
  end
end
