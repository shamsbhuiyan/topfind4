class Evidence2gocomponent < ActiveRecord::Base
  def self.add

    change_table :evidence2evidencecode do |t|  
      t.timestamps
    end
   end
  
  belongs_to :evidence
  belongs_to :gocomponent 
end
