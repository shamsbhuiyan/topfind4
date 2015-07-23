require File.expand_path("../../test_helper", __FILE__)

class InhibitionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :inhibitions
  test "the truth" do
    assert true
  end
  
  def test_find_inhibition
     inhibition = Inhibition.find(1)
     assert !inhibition.nil?
  end
  
  def test_save_inhibition
     
     sample_inhibition = Inhibition.new :created_at => "2014-08-09 20:42:00",
			      :updated_at => "2014-08-15 20:42:00",
			      :inhibitor_id => 4,
                                    :molecule_id => 3,
			      :inhibitory_molecule_id => 23,
			      :inhibited_proteaseisoform_id => 5,
			      :inhibited_proteasechain_id => 3,
			      :inhibited_protease_id => 3,
			      :import_id => 2,
			      :idstring => "P(Q9BYF1)-S(P05814)at(71)"
    assert sample_inhibition.save, "Could not save inhibitoion!"
  end
  
  def test_inhibition_attributes
  
    inhibition = Inhibition.find(2)
    assert inhibition.inhibitor_id == 145, "this is the wrong inhibitor id"
    assert inhibition.molecule_id == 2, "this is the wrong molecule id"
    assert inhibition.inhibitory_molecule_id == 2, "wrong inhibitory molecule"
    assert inhibition.inhibited_proteaseisoform_id == 2, "wrong inhibited_proteaseisoform id"
    assert inhibition.inhibited_proteasechain_id == 1, "wrong inhibited chain isoform id"
    assert inhibition.inhibited_protease_id == 1, "wrong protease id"
    assert inhibition.idstring == "I(I04.003)-P(S01.017)", "wrong idstring"
    assert inhibition.import_id == 2, "peptide wrong"
   
  end
end
