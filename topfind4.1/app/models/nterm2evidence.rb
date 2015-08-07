class Nterm2evidence < ActiveRecord::Base

  def self.add

    change_table :nterm2evidence do |t| 
      t.timestamps
    end
  end
  
  belongs_to :evidence
  belongs_to :nterm
  
end
