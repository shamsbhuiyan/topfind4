require File.expand_path("../../test_helper", __FILE__)

class IsoformTest < ActiveSupport::TestCase
   test "the truth" do
     assert true
   end
   def test_find_isoform

     iso = Isoform.find(1)
     assert !iso.nil?
  end
  def test_isoformhtmil
    iso = Isoform.find(1)
    puts iso.htmlsequence
  end
end
