class Terminusmodification < ActiveRecord::Base
  def self.add

    change_table :terminusmodification do |t| 
       t.string :ac, :index => true
       t.string :name, :index => true
       t.text :description
       t.boolean :nterm, :default => false
       t.boolean :cterm, :default => false
       t.string :subcell
       t.string :psimodid
       t.boolean :display, :default => true
       t.timestamps
    end
  end
  
  has_many :nterms
  has_many :cterms
  belongs_to :kw
  
end
