class Evidence2evidencecode < ActiveRecord::Base
  def self.add

    change_table :evidence2evidencecode do |t|  
      t.timestamps
    end
   end
   
    belongs_to :evidence
    belongs_to :evidencecode, :foreign_key => :code
end
