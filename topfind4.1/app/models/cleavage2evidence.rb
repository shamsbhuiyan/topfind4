class Cleavage2evidence < ActiveRecord::Base

  def self.add

    change_table :cleavage2evidences do |t| 
      t.timestamps
    end
  end
  
  belongs_to :evidence
  belongs_to :cleavage
  
end
