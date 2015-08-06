require File.expand_path("../../test_helper", __FILE__)

class CtermTest < ActiveSupport::TestCase
test "the truth" do
    assert true
  end
  
  def test_existence
    found = Cterm.find(1)
    assert !found.nil?
  end  
  
  def test_name
    found = Cterm.find(1)
    assert found.name == "1433B_HUMAN-1 (unknown)", "wrong cterm name: #{found.name}"
  end
   def test_id
    found = Cterm.find(1)
    assert found.externalid == "TCt1", "wrong cterm id"
  end
  
   def test_targeted_features
    found = Cterm.find(1)
    assert !found.targeted_features.nil?, "no target features?"
  end
  
   def test_modifications
    found = Cterm.find(1)
    puts "[#{found.modificationclass}]"
    assert found.modificationclass == "3D-structure", "wrong class yo"
  end
  
   def test_boundaries
    found = Cterm.find(1)
    assert !found.targeted_boundaries.nil?, "wrong boundaries yo"
  end
  
   def test_boundaries
    found = Cterm.find(1)
    puts "[#{found.map_to_isoforms}]"
    assert !found.targeted_boundaries.nil?, "wrong boundaries yo"
  end
end
