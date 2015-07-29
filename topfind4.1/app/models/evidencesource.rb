class Evidencesource < ActiveRecord::Base
  def self.add

    change_table :evidencecode do |t|
    
     t.string :dbid
     t.string :dbname
     t.string :dburl
     t.string :dbdesc
     t.timestamps
    end
  end

  has_many :evidences
end
