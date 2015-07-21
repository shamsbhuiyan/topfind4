#require '../test_helper'
require File.expand_path("../../test_helper", __FILE__)
class DocumentationTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  
  def test_name
     found_doc = Documentation.find(1)
     assert found_doc.name == "p-info"     
  end
  
  def test_short
     found_doc = Documentation.find(1)
     assert found_doc.short == "This section provides basic information retrieved from UniProtKB and MEROPS. Protein names and species and, if applicable, protease classification and isoforms are listed. The UniProtKB curated annotation is presented alongside the amino acid sequence. For further background information, links to the appropriate entries at UniProtKB and MEROPS are provided."     
  end
end
