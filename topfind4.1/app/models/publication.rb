class Publication < ActiveRecord::Base
  def self.add

    change_table :publication do |t|

      t.integer :pmid, :required
      t.string :title
      t.text :authors
      t.text :abstract
      t.string :ref  
      t.string :doi
      t.string :url
      t.timestamps
    end
  end
  
  has_many :evidence2publications
  has_many :evidences,->{true}, :through => :evidence2publications
  # belongs_to :protein  

  before_save :retrieve_medline
  
  def retrieve_medline
    require 'bio'
    
    # retrieve record from pubmed
    Bio::NCBI.default_email = "plange@interchange.ubc.ca"    
    pubmed = Bio::MEDLINE.new(Bio::PubMed.efetch(self.pmid).first)
    
    self.title = pubmed.ti
    self.authors = pubmed.au.gsub(/\n/,', ') #replace newlines by ,
    self.abstract = pubmed.ab
    self.ref = pubmed.so
    self.doi = ''
    aidarray = pubmed.instance_variable_get(:@pubmed)['AID'].chars.to_a
    aidarray.each do |id|
    	if id.include?('[doi]')
    		self.doi = id.gsub(/^(.*)+\[doi\]/,'\1') 
    	end
    end
    self.doi.length > 5 ? self.url = "http://dx.doi.org/#{self.doi}" : self.url = ''
  end
end
