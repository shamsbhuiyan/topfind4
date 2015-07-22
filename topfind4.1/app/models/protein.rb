class Protein < ActiveRecord::Base
  def self.add

    change_table :protein do |t|  
      t.string :ac, :required, :unique, :index => true
      t.string :name, :required, :unique, :index => true
      t.string :data_class
      t.integer :molecular_type
      t.string :entry_type
      t.string :dt_create
      t.string :dt_sequence
      t.string :dt_annotation
      t.string :definition
      t.text :sequence
      t.integer :mw
      t.string :crc64
      t.integer :aalen
      t.string :chromosome, :index => true
      t.string :band, :index => true
      t.string :meropsfamily, :index => true
      t.string :meropssubfamily, :index => true
      t.string :meropscode, :index => true
      t.enum   :status['created','pruned','updated','unknown'], :default => 'unknown'
      t.timestamps
    end
  end

  def to_param
    self.ac
  end
  
  #UniProt Protein Entry related 
  belongs_to :species 
  has_many :acs, -> { uniq }, :dependent => :destroy
  has_many :proteinnames, -> { uniq }, :dependent => :destroy
  has_many :searchnames, -> { uniq }, :dependent => :destroy
  #has_one :gn, :include => [:loci, :synonyms, :orf_names], :dependent => :destroy
  has_one :gn, -> { include(:loci, :synonyms, :orf_names) }, :dependent => :destroy
  has_and_belongs_to_many :oss, -> { uniq },  :join_table => :oss_proteins
  has_and_belongs_to_many :ocs, -> { uniq }
  has_and_belongs_to_many :oxs, -> { uniq }, :join_table => :oxs_proteins
  has_many :refs, -> {include(:rxs, :rgs, :rps, :rcs).uniq }, :dependent => :destroy
  has_many :ccs, -> { uniq }, :dependent => :destroy
  has_many :drs, -> { uniq }, :dependent => :destroy
  has_and_belongs_to_many :kws, -> { uniq }
  has_many :fts, -> { uniq }, :dependent => :destroy

  #has_many :publications,:accessible => true, :dependent => :destroy, :uniq => true
  has_many :publications, -> { uniq },:dependent => :destroy
  def to_param
    self.ac
  end

#Cleavage, Substrate, Inhibition related
  has_many :cleavages, -> { uniq }, :foreign_key => 'protease_id'
  #has_many :cleavages, :foreign_key => 'protease_id', :accessible => :true, :uniq => true
  has_many :substrates,-> { uniq }, :through => :cleavages
  has_many :inverse_cleavages, :class_name => "Cleavage", :foreign_key => "substrate_id"
  has_many :proteases, -> { uniq }, :through => :inverse_cleavages  
 
  has_many :inhibitions,-> { uniq }, :foreign_key => 'inhibited_protease_id'
  has_many :inhibitors, -> { uniq }, :through => :inhibitions
  has_many :inverse_inhibitions, :class_name => "Inhibition", :foreign_key => "inhibitor_id"
  has_many :inhibited_proteases, -> { uniq }, :through => :inverse_inhibitions

  has_many :chains, -> { uniq }
  has_many :cterms, -> { uniq }
  has_many :nterms, -> { uniq }
  
  has_many :isoforms, -> { uniq }
  has_many :isoforms, -> { uniq }
  
 def is_canonical
    !self.ac.include?('-') || self.ac.include?('-1')
  end
  
  def canonical_ac
  	self.ac.split('-').first
  end
  
  def htmlsequence
    numbering = ''
    blocks = (self.sequence.length/10).to_i + 1 # +1 added by nik to correct a bug (eg P63104)
    number=10
    blocks.times do |i|
      number = ((i+1)*10).to_s  # current digit
      if(i + 1 != blocks) then
        numbering = numbering.concat(' '*(10-number.length))  # adds empty space between digits
        numbering = numbering.concat(number)  # adds digits (0, 10, 20, 30,...)
      else # last block (the block that's not full, all full blocks get a number)
        numbering = numbering.concat('   ') # Nik added this, this is not superpretty (makes empty new line if the sequence is x*60 length)
      end
    end
    # break numbering string and sequence string into arrays (elements length 60) and add spaces in elements
    # Nik had to replace regexpr from /.{1,59}./ to /.{1,60}/ because otherwise a block with one element wouldn't be recognized (eg P04731)
    numberstrings = numbering.to_s.scan(/.{1,60}/).map {|s| s.gsub(/(.{10})/,'\1 ')} 
    seqstrings = self.sequence.scan(/.{1,60}/).map {|s| s.gsub(/(.{10})/,'\1 ')}
    # merge arrays alternating one by one (zip) and then join with new space (<br>)
    numberstrings.zip(seqstrings).flatten.join('<br/>').gsub(/ /,'&nbsp;').html_safe 
  end
  
  def recname
    if self.proteinnames.first
      return self.proteinnames.first.full
    else 
      return self.name
    end
  end
  
  def shortname
    self.name.split('_')[0] 
  end
  
  def isprotease
    if self.cleavages.empty?
      return false
    else
      return true
    end
  end
  
  def issubstrate
    if self.proteases.empty?
      return false
    else
      return true
    end
  end
  
  def isinhibitor
    if self.inhibitions.empty?
      return false
    else
      return true
    end
  end
  
  def active_features
    @domainfeatures = ['ACT_SITE','DNA_BIND','BINDING','CA_BIND','NP_BIND','METAL','ZN_FING'] 
    @res = Array.new
    self.fts.each do |ft|
      @res << ft if @domainfeatures.include?(ft.name)
    end
    @res.sort! {|x,y| x.from.to_i <=> y.from.to_i}
    @res
  end
  
    def domains
    @domainfeatures = ['DOMAIN','MOTIF','PEPTIDE','PROPEP','REGION','SIGNAL','INIT_MET','SITE','TRANSIT'] 
    @res = Array.new
    puts "[]"
    self.fts.each do |ft|
      puts "[#{ft}]"
      @res << ft if @domainfeatures.include?(ft.name)
    end
    @res.sort! {|x,y| x.from.to_i <=> y.from.to_i}
    @res
    #puts @res
  end 
  
  def isoform_crossmapping(pos,orientation)
    window = 20 # length of the sequence that must be identical for mapping
    result = {}

    case orientation
      when 'left'
        from_sequence = self.sequence[pos-1-window..pos-1]
      when 'right'
        from_sequence = self.sequence[pos-1..pos-1+window]
      when 'centre' 
        from_sequence = self.sequence[pos-1-(window/2)..pos-1+(window/2)]
    end


    self.is_canonical ? canonical = self : canonical = Protein.find_by_ac(self.ac.split('-')[0])
    ac_list = canonical.isoforms.map {|x| x.ac}<<canonical.ac

    ac_list.each do |ac|
      unless ac == self.ac
        mapto = Protein.find_by_ac(ac)
        next unless mapto.present?
        case orientation
          when 'left'
          to_pos = mapto.sequence.index(from_sequence)+1+window if mapto.sequence.scan(from_sequence).count ==  1
          when 'right'
          to_pos = mapto.sequence.index(from_sequence)+1 if mapto.sequence.scan(from_sequence).count ==  1
          when 'centre'
          to_pos = mapto.sequence.index(from_sequence)+1+(window/2) if mapto.sequence.scan(from_sequence).count ==  1
        end
      	result[ac] = to_pos if to_pos.present?
      end
    end
    return result
  end
  
  def self.id_or_ac_or_name_is(q)
    prot = Array.new
    id = Protein.find_by_id(q)
    ac = Protein.find_by_ac(q)
    name = Protein.find_by_name(q)
    if !id.nil?
      prot.push(id)
    elsif !ac.nil?
      prot.push(ac)
    elsif !name.nil?
      prot.push(name)
    end
    return prot
  end
end

##Uniprot related Classes
#UniProt related classes 
class Proteinname < ActiveRecord::Base 
  belongs_to :protein
  
  def view_permitted?(field)
    true
  end  
end
class Searchname < ActiveRecord::Base
  belongs_to :protein
end

class Ac < ActiveRecord::Base
  belongs_to :protein
end

class De < ActiveRecord::Base
  belongs_to :protein
end

class Gn < ActiveRecord::Base
  has_many :synonyms,  :table_name => 'GnSynonym', :class_name => 'GnSynonym'
  has_many :loci,      :table_name => 'GnLocus',   :class_name => 'GnLocus'
  has_many :orf_names, :table_name => 'GnOrfName', :class_name => 'GnOrfName'
end

class GnSynonym < ActiveRecord::Base
  belongs_to :gn
end

class GnLocus < ActiveRecord::Base
  self.table_name = "gn_loci"
  belongs_to :gn
end

class GnOrfName < ActiveRecord::Base
  belongs_to :gn
end



class Os < ActiveRecord::Base
  self.table_name = "oss"
  has_and_belongs_to_many :proteins, :join_table => :oss_proteins, :uniq => true
  
  def view_permitted?(field)
    true
  end  
end

class Oc < ActiveRecord::Base
  has_and_belongs_to_many :proteins
  
  def view_permitted?(field)
    true
  end  
end

class Ox < ActiveRecord::Base
  self.table_name = "oxs"
  has_and_belongs_to_many :proteins, :join_table => :proteins_oxs
  
  def view_permitted?(field)
    true
  end  
end

class Ref < ActiveRecord::Base
  belongs_to :protein
  has_many :rxs
  has_many :rps
  has_many :rcs
  has_many :rgs
end

class Rx < ActiveRecord::Base
  self.table_name = 'rxs'
  belongs_to :ref
end

class Rg < ActiveRecord::Base
  belongs_to :ref
end

class Rp < ActiveRecord::Base
  belongs_to :ref
end

class Rc < ActiveRecord::Base
  belongs_to :ref
  
  def view_permitted?(field)
    true
  end  
end

class Cc < ActiveRecord::Base
  belongs_to :protein
  
  scope :main,->{ where(:conditions => "`topic` = 'CATALYTIC ACTIVITY' OR `topic` = 'DISEASE' OR `topic` = 'FUNCTION' OR `topic` = 'SUBCELLULAR LOCATION' = `topic` = 'TISSUE SPECIFICITY'") }
  scope :additional, ->{ where(:conditions => "`topic` != 'ALLERGEN' AND `topic` != 'ALTERNATIVE PRODUCTS' AND `topic` != 'BIOPHYSICOCHEMICAL PROPERTIES' AND `topic`!= 'BIOTECHNOLOGY' AND `topic` != 'DISEASE' AND `topic` != 'INTERACTION' AND `topic` != 'FUNCTION' AND `topic` != 'MASS SPECTROMETRY' AND `topic` != 'PHARMACEUTICAL' AND `topic` != 'RNA EDITING' AND `topic` != 'SUBCELLULAR LOCATION' AND `topic` != 'TISSUE SPECIFICITY' AND `topic` != 'WEB RESOURCE'") }
end

class Dr < ActiveRecord::Base

  belongs_to :protein
  
  def view_permitted?(field)
    true
  end  
end

class Kw < ActiveRecord::Base
   def self.add
    change_table(:kw) do |t|  
      t.string :name, :required, :unique, :index => true  
      t.string :ac, :index => true
      t.string :description
      t.string :category
    end
   end
  
  has_and_belongs_to_many :proteins
  has_many :terminusmodifications
  has_many :kwsynonymes
end

class Kwsynonyme < ActiveRecord::Base
   def self.add
     change_table :kwsynonyme do |t| 
       t.string :string, :required, :unique, :index => true  
     end
   end
  
  belongs_to :kw
end
class Ft < ActiveRecord::Base

  belongs_to :protein
  has_many :chains, :through => :protein
  
  scope :present, lambda { |from,to|
    {:conditions => ['`from` >= ? AND `to` <= ?',from,to] }
  }
  
  scope :absent, lambda { |from,to|
    {:conditions => ['(`to` < ? ) OR ( `from` > ?)',from,to] }
  }
  
  scope :before, lambda { |pos|
    {:conditions => ['(`to` <= ? )' ,pos] }
  }
  
  scope :after, lambda { |pos|
    {:conditions => ['( `from` > ?)',pos] }
  }    
  
  # domains that are fully in this chunk
  scope :spanning, lambda { |from,to|
    {:conditions => ['(`from` <= ? ) AND ( `to` >= ?)',from,to] }
  }
  
  # features that start or end at this position
  scope :matching, lambda { |pos|
    {:conditions => ['(`from` = ? ) OR ( `to` = ?)',pos,pos-1] }
  }
  
  scope :matchfrom, lambda { |pos|
    {:conditions => ['(`from` = ? )', pos] }
  }
  
  scope :matchto, lambda { |pos|
    {:conditions => ['(`to` = ? )', pos] }
  }  
  
  
  def view_permitted?(field)
    true
  end   
end
