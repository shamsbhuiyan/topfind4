require File.expand_path("../../test_helper", __FILE__)

class CleavageTest < ActiveSupport::TestCase
 def test_find_cleavage
     cleavage = Cleavage.find(1)
     assert !cleavage.nil?
  end

  def test_save_cleavage
     
     sample_cleavage = Cleavage.new :protease_id => 7,
                                    :substrate_id => 4,
                                    :import_id => 3,
			      :pos => 23,
			      :created_at => "2014-08-09 20:42:00",
			      :updated_at => "2014-08-15 20:42:00",
			      :cterm_id => 5,
			      :nterm_id => 3,
			      :cleavagesite_id => 3,
			      :nterm_id => 2,
			      :proteaseisoform_id => 7,
			      :proteaseisoform_id => 4,
			      :proteasechain_id => 2,
			      :substrateisoform_id => 3,
			      :substratechain_id => 2,
			      :idstring => "P(Q9BYF1)-S(P05814)at(71)",
			      :peptide => "PQRS"
    assert sample_cleavage.save, "Could not save cleavage!"
  end
  
    def test_cleavage_attributes
     cleavage = Cleavage.find(2)
     assert cleavage.substrate_id == 1, "this is the wrong substrate id"
     #puts cleavage.import_id
     assert cleavage.protease_id == 1, "this is the wrong protease id"
     assert cleavage.import_id.nil?, "this is the wrong import id"
     assert cleavage.pos == 45, "this is wrong position"
     assert cleavage.cterm_id == 93852, "this is wrong cterm id"
     assert cleavage.nterm_id == 2, "this is wrong nterm id"
     assert cleavage.cleavagesite_id == 1, "this is wrong cleavage_site id"
     assert cleavage.proteaseisoform_id == 3, "this is wrong protease isoform id"
     assert cleavage.proteasechain_id == 4, "this is wrong protease chain id"
     assert cleavage.substrateisoform_id == 1, "this is wrong substrate isoform id"
     assert cleavage.substratechain_id == 1, "this is wrong substrate chain id"
     assert cleavage.idstring.to_s == "P(Q9BYF1)-S(P01019)at(40)", "this is wrong idstring"
     assert cleavage.peptide.nil?, "this is wrong peptide data"
  end
end
