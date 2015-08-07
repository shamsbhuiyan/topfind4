class Molecule < ActiveRecord::Base

  def self.add

    change_table :molecule do |t| 
      
      t.string :name
      t.text :description
      t.string :formula
      t.string :external_id
      t.string :source
      t.timestamps
    end
  end
  
    
  has_many :inhibitions
  has_many :proteases, :foreign_key => 'protease_id', :accessible => :true
  has_many :moleculenames  
end
