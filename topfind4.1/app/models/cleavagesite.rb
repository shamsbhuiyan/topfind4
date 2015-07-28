require 'matrix'

class Cleavagesite < ActiveRecord::Base
 def self.add

    change_table :cleavagesite do |t|  
      t.string :idstring, :required, :unique
      t.string :p10, :default => ''
      t.string :p9, :default => ''
      t.string :p8, :default => ''
      t.string :p7, :default => ''
      t.string :p6, :default => ''
      t.string :p5, :default => ''
      t.string :p4, :default => ''
      t.string :p3, :default => ''
      t.string :p2, :default => ''
      t.string :p1, :default => ''
      t.string :p1p, :default => ''
      t.string :p2p, :default => ''
      t.string :p3p, :default => ''
      t.string :p4p, :default => ''
      t.string :p5p, :default => ''
      t.string :p6p, :default => ''
      t.string :p7p, :default => ''
      t.string :p8p, :default => ''
      t.string :p9p, :default => ''
      t.string :p10p, :default => ''
      t.timestamps
    end
  end
  
  has_one :cleavage
  has_one :protease, :through => :cleavage

  belongs_to :import 
  
  def name
    name = "#{short_seq} by #{protease.name}"
    name
  end
  
  def short_seq
    "#{p4}#{p3}#{p2}#{p1}.<span class='cleavagedelimiter'>|</span>.#{p1p}#{p2p}#{p3p}#{p4p}"
  end
  
  def piped_seq 
    "#{p4}#{p3}#{p2}#{p1}|#{p1p}#{p2p}#{p3p}#{p4p}"
  end

  def seq
   npseq = [p5,p4,p3,p2,p1]
   (5-npseq.count).times {npseq = npseq.unshift('X')}
   pseq = [p1p,p2p,p3p,p4p,p5p]
   (5-pseq.count).times {pseq = pseq.push('X')} 
   seq = npseq.concat(pseq)
   return "#{seq.to_s}"  
  end
  
  def seq_x
   npseq = [p5,p4,p3,p2,p1]
   (5-npseq.count).times {npseq = npseq.unshift('X')}
   pseq = [p1p,p2p,p3p,p4p,p5p]
   (5-pseq.count).times {pseq = pseq.push('X')} 
   seq = npseq.concat(pseq)
   seq.map! {|p| p == '' || p== nil ? 'X' : p}
   return "#{seq.to_s}"  
  end  
  
  def seq_z
   npseq = [p6,p5,p4,p3,p2,p1]
   (6-npseq.count).times {npseq = npseq.unshift('Z')}
   pseq = [p1p,p2p,p3p,p4p,p5p,p6p]
   (6-pseq.count).times {pseq = pseq.push('Z')} 
   seq = npseq.concat(pseq)
   seq.map! {|p| p == '' || p== nil ? 'Z' : p}
   return "#{seq.to_s}"  
  end  
  
  def cleavagesitematrix(np,p)
    nonprimerange = (1..np).to_a.reverse
    primerange = 1..p
    @matrixarray = Array.new
    
    nonprimerange.each do |i|
      @matrixarray.push(self.asvector(self.attributes["p#{i}"]))
    end
    primerange.each do |i|
      @matrixarray.push(self.asvector(self.attributes["p#{i}p"]))
    end
    
    # @matrixarray
    
    matrix = Matrix.rows(@matrixarray)
    
    # y matrix
    
    return matrix            
  end
  
  def asvector(as)
    case as
      when 'A'
        return [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'C'
        return [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'D'
        return [0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'E'
        return [0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'F'
        return [0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'G'
        return [0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'H'
        return [0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'I'
        return [0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0]
      when 'K'
        return [0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0]
      when 'L'
        return [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0]
      when 'M'
        return [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0]
      when 'N'
        return [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0]
      when 'P'
        return [0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0]
      when 'Q'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0]
      when 'R'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0]
      when 'S'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]
      when 'T'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0]
      when 'V'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0]
      when 'W'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0]
      when 'Y'
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]
      else
        return [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    end    
  end
end
