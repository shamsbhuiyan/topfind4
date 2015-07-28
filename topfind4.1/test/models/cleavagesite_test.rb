require File.expand_path("../../test_helper", __FILE__)
class CleavagesiteTest < ActiveSupport::TestCase
    fixtures :cleavagesites
  
  test "the truth" do
    assert true
  end
  
  def test_find_cleavagesite

     cleave = Cleavagesite.find(1)
     assert !cleave.nil?
  end

  def test_save_CleavageSite
  
    sample = Cleavagesite.new     :id => 3,
			    :p10 => "A",
			    :p9 => "A",
			    :p8 => "A",
			    :p7 => "A",
			    :p6 => "A",
			    :p5 => "A",
			    :p4 => "F",
			    :p3 => "E",
			    :p2 => "D",
			    :p1 => "C",
			    :p10p => "C",
			    :p9p => "Q",
			    :p8p => "Q",
			    :p7p => "L",
			    :p6p => "R",
			    :p5p => "E",
			    :p4p => "E",
			    :p3p => "E",
			    :p2p => "E",
			    :p1p => "T"
       assert sample.save, "Cleavagesite did not save"
  end
  
    $found = Cleavagesite.find(1)
  def test_find_attribute
   #found = Cleavagesite.find(1)
   assert $found.p10 == "A", "WRONG P10 VALUE"
  end

  ##this tests short_seq in the process as well
  def test_name
    #found = Cleavagesite.find(1)
    assert $found.name == "IJKL.<span class='cleavagedelimiter'>|</span>.LKJI by 1433B_HUMAN"
  end
  
  def test_piped_seq
    
    assert $found.piped_seq == "IJKL|LKJI", "wrong pipe seq #{$found.piped_seq}"
  end
  
  def test_seq
    array =  []
    assert $found.seq == '"H", "I", "J", "K", "L", "L", "K", "J", "I", "H"', "wrong seq #{$found.seq}"
  end
  
  def test_seq_x
    array = ["H", "I", "J", "K", "L", "L", "K", "J", "I", "H"]
    assert $found.seq_x == "HIJKLLKJIH", "wrong seqx #{$found.seq_x}"
  end
  
  def test_seq_z
    assert $found.seq_z == "GHIJKLLKJIHG", "swrong seqz #{$found.seq_z}"
  end
  
  def test_matrix
    assert !$found.cleavagesitematrix(5,5).nil?
  end
end
