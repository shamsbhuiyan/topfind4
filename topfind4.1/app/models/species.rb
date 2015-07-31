class Species < ActiveRecord::Base
  def self.add

    change_table :species do |t| 
      t.string :name, -> { uniq }, :required, :index => true
      t.string :common_name, -> { uniq }, :index => true
    end
  end
  has_many :proteins  
end
