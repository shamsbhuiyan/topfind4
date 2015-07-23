class Chain < ActiveRecord::Base
def self.add

    change_table :chain do |t|
    
    
    t.string :idstring, :unique
    t.string :name
    t.text :description
    t.integer :from
    t.integer :to
    t.timestamps
    end
  end
  
  belongs_to :protein
  belongs_to :isoform
  
  has_many :cleavages, :foreign_key => 'proteasechain_id'
  has_many :substrates, :through => :cleavages
  has_many :inverse_cleavages, :class_name => "Cleavage", :foreign_key => "substratechain_id"
  has_many :proteases, :through => :inverse_cleavages 
  
  belongs_to :cterm
  belongs_to :nterm 

 has_many :chain2evidences
 has_many :evidences, :through => :chain2evidences
    
 has_many :fts, :through => :protein


  def htmlsequence
    self.protein.sequence.gsub(/(.{5})/,'\1 ')
  end
  
end
