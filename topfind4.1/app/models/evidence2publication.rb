class Evidence2publication < ActiveRecord::Base
  def self.add

    change_table :evidence2publication do |t| 
      t.timestamps
    end
  
  end
  
  belongs_to :evidence
  belongs_to :publication
end
