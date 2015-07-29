require 'fastercsv'
require 'csv'
require 'paperclip'

class Import < ActiveRecord::Base
  def self.add

    change_table :import do |t|
    
      t.string :name, :required => true
      t.text :description
      t.enum :datatype['proteases cleaving a protein','proteases cleaving a peptide','proteases inhibited by protein inhibitors','N-termini','C-termini']
      t.integer :inhibitions_listed, :default => 0
      t.integer :inhibitions_imported, :default => 0
      t.integer :cleavages_listed, :default => 0
      t.integer :cleavages_imported, :default => 0
      t.integer :cleavagesites_listed, :default => 0
      t.integer :cleavagesites_imported, :default => 0
      t.integer :cterms_listed, :default => 0
      t.integer :cterms_imported, :default => 0
      t.integer :nterms_listed, :default => 0
      t.integer :nterms_imported, :default => 0
      t.timestamps
    end
  end
  
  has_many :cleavages, :dependent => :destroy
  has_many :cleavagesites, :dependent => :destroy
  has_many :inhibitions, :dependent => :destroy
  has_many :cterms, :dependent => :destroy
  has_many :nterms, :dependent => :destroy
  belongs_to :evidence
  has_attached_file :csvfile
  
  #belongs_to :owner, :class_name => "User", :creator => true
end
