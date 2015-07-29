class Evidencecode < ActiveRecord::Base
  def self.add

    change_table :evidencecode do |t|
      t.string :code
      t.string :name
      t.text :definition
      t.timestamps
    end
   end
  has_many :evidence2evidencecodes
  has_many :evidences, :through => :evidence2evidencecodes 
end
