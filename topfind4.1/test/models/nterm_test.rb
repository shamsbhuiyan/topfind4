require File.expand_path("../../test_helper", __FILE__)

class NtermTest < ActiveSupport::TestCase
test "the truth" do
    assert true
  end
  
  def test_existence
    found = Nterm.find(1)
    assert !found.nil?
  end  
  
  def test_name
    found = Nterm.find(1)
    assert found.name == "P31946-1-Acetylation", "wrong cterm name: #{found.name}"
  end
  
   def test_targeted_features
    found = Nterm.find(1)
    assert !found.targeted_features.nil?, "no target features?"
  end
  
  def test_modifications
    found = Nterm.find(1)
    puts "[#{found.modificationclass}]"
    assert found.modificationclass == "3D-structure", "wrong class yo"
  end
  
   def test_boundaries
    found = Nterm.find(1)
    assert !found.targeted_boundaries.nil?, "wrong boundaries yo"
  end
  
   def test_isoform
    found = Nterm.find(1)
    puts "[#{found.map_to_isoforms}]"
    assert !found.targeted_boundaries.nil?, "wrong boundaries yo"
  end
  
  def test_fasterCSV
    found = Nterm.find(1)
    puts Nterm.generate_csv([1,2])
  end
end
