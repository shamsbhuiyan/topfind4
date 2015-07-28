require File.expand_path("../../test_helper", __FILE__)

class PublicationTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :publications
  
  def test_find_publication

     publication = Publication.find(1)
     assert !publication.nil?
  end
  
  def test_save_publication
  
    sample = Publication.new      :pmid => 1234,
			    :title => "werty123",
			    :authors => "Bhuiyan S, Bhuiyan S",
			    :abstract => "I'm hungry",
			    :ref => "what should I put here?",
			    :url => "www.facebook.com",
			    :created_at  => "2014-07-31 23:51:30",
                                  :updated_at => "2014-08-01 15:24:59"
       assert sample.save, "Publication did not save"
  end
  
  def test_found_publication
  
    found = Publication.find(1)
    assert found.pmid == 1259062, "this is the pmid"
    assert found.title == "Some random title", "this is the wrong title"
    assert found.authors == "A whole list of authors, commas", "this is the wrong authors"
    assert found.ref == "J Biol Chem. 2002 Apr 26;277(17):14838-43. Epub 2002 Jan 28.", "wrong ref"
    assert found.doi == "10.1074/jbc.M200581200"
    assert found.url == "http://potatos.com"
    
  end
end
