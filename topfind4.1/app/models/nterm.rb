class Nterm < ActiveRecord::Base

  def self.add

    change_table :nterm do |t| 
      t.integer :protein_id
      t.integer :pos
      t.string :idstring, :unique
      t.string :seqexcerpt, :index => :true
      t.timestamps
    end
  end
     default_scope {order('pos ASC')}

  has_many :chains
  has_many :cleavages
  belongs_to :isoform
  belongs_to :protein

  belongs_to :terminusmodification
  
  belongs_to :import
  
  has_many :nterm2evidences
  has_many :evidences, -> {uniq}, :through => :nterm2evidences
  
  def name
    self.idstring
  end
  
  def externalid
  	"TNt#{self.id}"
  end 
   
  def targeted_features
    self.protein.fts.spanning(self.pos-3,self.pos+4)
  end
  
  def modificationclass
  	name = ''
  	if self.terminusmodification.present?
  		name = self.terminusmodification.kw.name if self.terminusmodification.kw.present?
 	end
 	return name
  end
  
  def targeted_boundaries(type = 'match')
  	case type
  		when 'match' 
    		self.protein.fts.matchfrom(self.pos)
    	when 'lost'
    		self.protein.fts.matchto(self.pos-1)
	end
  end  

  def map_to_isoforms
	  
	  mapping = self.protein.isoform_crossmapping(self.pos,'right')
	  
	  if mapping.present?
		  #generate "inferred from isoform" evidence
		  @isoevidence = Evidence.find_or_create_by_name(:name => "inferred from #{self.externalid}",
			:idstring => "inferred-isoform-#{self.externalid}",
			:description => 'The stated informations has been inferred from an isoform by sequence similarity at the stated position.',
			:phys_relevance => "unknown",
			:directness => 'indirect',
			:method => 'electronic annotation'
		  )
		  @isoevidence.evidencesource = Evidencesource.find_or_create_by_dbid(
			:dbname => "TopFIND",
			:dbid => self.externalid,
			:dburl => "http://clipserve.clip.ubc.ca/topfind/proteins/#{self.protein.ac}\##{self.externalid}"
		  ) 	
		  @isoevidence.evidencecodes << Evidencecode.find_or_create_by_name(:name => 'inferred from isoform by sequence similarity',																	:code => 'TopFIND:0000002')
		  @isoevidence.save
	  end
	
	  mapping.each_pair do |ac,pos|
	    matchprot = Protein.ac_is(ac).first
	  	nterm = Nterm.find_or_create_by_idstring(:idstring => "#{ac}-#{pos}-#{self.terminusmodification.name}",:protein_id => matchprot.id, :pos => pos, :terminusmodification => self.terminusmodification )
		nterm.evidences << @isoevidence unless nterm.evidences.include?(@isoevidence)
		matchprot.nterms << nterm unless matchprot.nterms.include?(nterm)
	  end
  end



  def self.generate_csv(ids)
    CSV.generate({:col_sep => "\t"}) do |csv|
      csv << ['topfind terminus id','position','sequence','protein (uniprot ac)','topfind evidence ids']
      ids.each do |id|
        n = Nterm.find(id)       
        csv << [n.externalid,n.pos,n.protein.sequence[n.pos-1..n.pos+9],n.protein.ac,n.evidences.collect{|e| e.externalid}.join(':')]
      end
    end  
  end 
  
end
