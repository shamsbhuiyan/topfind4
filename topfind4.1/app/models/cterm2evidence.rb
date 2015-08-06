class Cterm2evidence < ActiveRecord::Base
  def self.add

    change_table :cterm2evidence do |t| 
      t.timestamps
    end
  end
  
  belongs_to :evidence
  belongs_to :cterm
end
