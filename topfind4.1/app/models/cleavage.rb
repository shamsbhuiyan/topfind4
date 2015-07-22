class Cleavage < ActiveRecord::Base
  def self.add

    change_table :cleavage do |t|  
      t.string :idstring, :unique
      t.integer :pos
      t.string :peptide
      t.timestamps
    end
  end
  #S.B I think this version is correct?
  #it worked, I replaced this: default_scope :order => 'pos ASC'
  #I think this default scope part just tells us to order by ac number by default
  default_scope {order('pos ASC')}
  
  belongs_to :protease, :class_name => 'Protein', :foreign_key =>'protease_id'
  belongs_to :substrate, :class_name => 'Protein', :foreign_key =>'substrate_id'
  
  belongs_to :proteaseisoform, :class_name => 'Isoform', :foreign_key => 'proteaseisoform_id'
  belongs_to :proteasechain, :class_name => 'Chain', :foreign_key => 'proteasechain_id'
  
  belongs_to :substrateisoform, :class_name => 'Isoform', :foreign_key => 'substrateisoform_id'
  belongs_to :substratechain, :class_name => 'Chain', :foreign_key => 'substratechain_id'
  
  belongs_to :cleavagesite
  
  belongs_to :cterm, :dependent => :destroy
  belongs_to :nterm, :dependent => :destroy
   
  # has_many :evidencerelations, :as => :traceable
  # has_many :evidences, :through => :evidencerelations, :accessible => true    
  
  has_many :cleavage2evidences
  has_many :evidences, -> { uniq }, :through => :cleavage2evidences
  
  belongs_to :import
end
