require 'fastercsv'
require 'csv'
class Evidence < ActiveRecord::Base
  def self.add

    change_table :evidence do |t|  
      t.string :idstring, :unique
      t.string :name, :required, :index => true
      t.string :method, :index => true
      t.enum :method_system['cell free','cell culture','organ or tissue culture','in vivo sample','unknown'], :default => 'unknown', :index => true
      t.string :method_perturbation, :index=> true, :default => ''
      t.enum :method_protease_source['recombinant','natural expression','over expression','knockdown (expression)','genetic knockout','knockdown (functional, protease drug or blocking antibody or inhibitor used)','unknown'], :default => 'unknown', :index => true
      t.enum :methodology['other','electronic annotation','COFRADIC','N-TAILS','C-TAILS','ATOMS','Subtiligase Based Positive Selection','Edman sequencing','enzymatic biotinylation','chemical biotinylatin','MS gel band','MS semi-tryptic peptide','MS other','mutation analysis','unknown'], :default => 'unknown', :index => true
      t.enum :proteaseassignment_confidence['I no other proteolytic activities present', 'II proteolytic system present but abolished', 'III proteolytic system present but impaired', 'IV proteolytic system present and active','unknown'], :default => 'unknown', :index => true
      t.text :description
      t.string :repository 
      t.string :lab, :index => true
      t.enum :phys_relevance['unknown','none','unlikely','likely','yes'], :default => 'unknown', :index => true
      t.enum :directness['unknown','direct','likely direct','likely indirect','indirect'], :default => 'unknown', :index => true
      t.string :protease_inhibitors_used
      t.float :confidence, :default => nil
      t.enum :confidence_type['unknown','probability','ProteinProspector','MASCOT score','X! Tandem score','PeptideProphet probability'], :default => 'unknown'
      t.timestamps
    end
  end
  
  has_many :evidence2tissues
  has_many :tissues, -> { uniq }, :through => :evidence2tissues
  # has_many :evidence2cellines
  # has_many :celllines, :through => :evidence2cellines, :accessible => true
  has_many :evidence2gocomponents
  has_many :gocomponents, -> { uniq }, :through => :evidence2gocomponents 
  
  has_many :evidence2evidencecodes
  has_many :evidencecodes, -> { uniq }, :through => :evidence2evidencecodes, :foreign_key => :code  
  
  belongs_to :evidencesource
  
  has_many :evidence2publications
  has_many :publications, -> { uniq },  :through => :evidence2publications, :dependent => :destroy
  
  #need paperclip?
=begin
  has_attached_file :evidencefile, :dependent => :destroy, :styles => {
    :thumb => ["50x50>", :png],
    :small => ["300x400>",:png],
    :large => ["900x900>",:png]
  }
  has_many :imports
=end
  # has_many :evidencerelations
  # has_many :cleavages, :through => :evidencerelations , :source => :taceable, :source_type => 'Cleavage' 
  # has_many :nterms, :through => :evidencerelations, :source => :taceable, :source_type => 'Nterm'
  # has_many :cterms, :through => :evidencerelations, :source => :taceable, :source_type => 'Cterm'  
  # has_many :chains, :through => :evidencerelations, :source => :taceable, :source_type => 'Chain'   
  
  has_many :cleavage2evidences
  has_many :cleavages, :through => :cleavage2evidences
  has_many :inhibition2evidences
  has_many :inhibitions, :through => :inhibition2evidences
  has_many :cterm2evidences
  has_many :cterms, :through => :cterm2evidences
  has_many :nterm2evidences
  has_many :nterms, :through => :nterm2evidences
  has_many :chain2evidences
  has_many :chains, :through => :chain2evidences
  

  #belongs_to :owner, :class_name => "User", :creator => true  
  
  #need paperclip?
  #before_post_process :process?
  
  def externalid
  	"TE#{self.id}"
  end

  #need the faster CSV gem
  def self.generate_csv(ids)
    CSV.generate({:col_sep => "\t"}) do |csv|
      csv << ['topfind evidence id','name','method','description','lab','repository','physiological relevance','directness of detection','confidence','tissues','publications (PubMed id)','evidencecode names','evidencecodes']
      ids.each do |id|
        e = Evidence.find(id)       
        csv << [e.externalid,e.name,e.method,e.description,e.lab,e.repository,e.phys_relevance,e.directness,"#{e.confidence.to_s} #{e.confidence_type}",e.publications{|a| a.pmid}.join(':'),e.evidencecodes.collect{|c| c.name}.join(':'),e.evidencecodes.collect{|f| f.code}.join(':')]
      end
    end  
  end 

  
  def process?
    :image || :pdf
  end
  
  def image?
    !(evidencefile_content_type =~ /^image.*/).nil?
  end
  
  def pdf?
    !(evidencefile_content_type =~ /^application\/pdf.*/).nil?
  end
end
