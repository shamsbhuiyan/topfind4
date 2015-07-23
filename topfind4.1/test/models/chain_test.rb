require File.expand_path("../../test_helper", __FILE__)

class ChainTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
   def test_found_evidence
    found = Chain.find(1)
    assert !found.nil?
  end
  
  def test_htmlseq
    found = Chain.find(1)
    puts found.htmlsequence
    assert found.htmlsequence == "MTMDK SELVQ KAKLA EQAER YDDMA AAMKA VTEQG HELSN EERNL LSVAY KNVVG ARRSS WRVIS SIEQK TERNE KKQQM GKEYR EKIEA ELQDI CNDVL ELLDK YLIPN ATQPE SKVFY LKMKG DYFRY LSEVA SGDNK QTTVS NSQQA YQEAF EISKK EMQPT HPIRL GLALN FSVFY YEILN SPEKA CSLAK TAFDE AIAEL DTLNE ESYKD STLIM QLLRD NLTLW TSENQ GDEGD AGEGE N", "wrong id"
  end
end
