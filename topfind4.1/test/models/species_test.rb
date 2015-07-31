require File.expand_path("../../test_helper", __FILE__)

class SpeciesTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end
   
   def test_save_species
     sample_species = Species.new :name => "Batman",
			    :common_name => "(I'm BATMAN)"
     assert sample_species.save, "Protein did not save"
   end
end
